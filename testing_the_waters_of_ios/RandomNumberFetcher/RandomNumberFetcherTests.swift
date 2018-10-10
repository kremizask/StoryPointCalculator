//
//  RandomAPITests.swift
//  testing_the_waters_of_iosTests
//
//  Created by Kostas Kremizas on 06/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import XCTest
@testable import testing_the_waters_of_ios

class HttpClientFake: HttpClient {
    
    class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCalled = false
        
        private let completion: (Data?, URLResponse?, Error?) -> Void
        private let fakeResponse: Data?
        
        init(response: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
            self.completion = completionHandler
            self.fakeResponse = response
        }
        
        override func resume() {
            resumeCalled = true
            completion(fakeResponse, nil, nil)
        }
    }
    
    private let response: Data?
    
    public init(response: Data? = nil) {
        self.response = response
    }
    
    var requests: [URLRequest] = []
    var dummyDataTasks: [URLSessionDataTaskSpy] = []
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        requests.append(request)
        let task = URLSessionDataTaskSpy(response: response, completionHandler: completionHandler)
        dummyDataTasks.append(task)
        completionHandler(response, nil, nil)
        return task
    }
}

class RandomNumberFetcherTests: XCTestCase {
    var sut: RandomNumberFetcher!

    func testFetchRequestsADataTaskAndResumesIt() {
        // Arrange
        let httpClientSpy = HttpClientFake()
        let sut = RandomNumberFetcher(httpClient: httpClientSpy)
        
        var firstRequest: URLRequest? {
            return httpClientSpy.requests.first
        }
        
        // Act
        sut.fetchRandomNumber {_,_  in }
        
        // Assert
        XCTAssertEqual(httpClientSpy.requests.count, 1)
        XCTAssertEqual(httpClientSpy.dummyDataTasks.count, 1)
        XCTAssertEqual(httpClientSpy.dummyDataTasks.first?.resumeCalled, true)
        XCTAssertEqual(firstRequest?.httpMethod, "POST")
        XCTAssertEqual(firstRequest?.url?.absoluteString, "https://api.random.org/json-rpc/1/invoke")
        XCTAssertEqual(firstRequest?.value(forHTTPHeaderField: "Content-Type"), "application/json-rpc")
        
        let jsonString = """
        {
            "jsonrpc":"2.0",
            "method":"generateIntegers",
            "params":{
                "apiKey":"ec06126f-4d95-4757-abcb-74eebc65fcdb",
                "n":1,
                "min":0,
                "max":8,
                "replacement":true,
                "base":10
            },
            "id":0
        }
        """
        
        assertEqualsAfterDecoding(json: jsonString, requestBody: firstRequest?.httpBody)
    }
    
    private func assertEqualsAfterDecoding(json jsonString: String, requestBody: Data?) {
        let jsonData = jsonString.data(using: .utf8)!
        let sut = try! JSONDecoder().decode(RandomNumberFetcher.RequestBody.self, from: jsonData)
        let expectedValue = requestBody.flatMap { try? JSONDecoder().decode(RandomNumberFetcher.RequestBody.self, from: $0) }
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testTheResponseNumberInTheCallback() {
        
        // Arrange
        let response = RandomNumberFetcher.Response(result: .init(random: .init(data: [2])))
        let responseData = try? JSONEncoder().encode(response)
        let httpClient = HttpClientFake(response: responseData)
        let sut = RandomNumberFetcher(httpClient: httpClient)
        
        // Act
        
        var result: Int?
        var responseError: Error?
        sut.fetchRandomNumber { (number, error) in
            result = number
            responseError = error
        }
        
        XCTAssertEqual(result, 2)
        XCTAssertNil(responseError)
    }
}
