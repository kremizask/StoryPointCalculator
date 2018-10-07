//
//  RandomNumberFetcher.swift
//  testing_the_waters_of_ios
//
//  Created by Kostas Kremizas on 06/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import Foundation

protocol RandomNumberFetcherProtocol {
    func fetchRandomNumber(completion: @escaping (Int?, Error?) -> Void)
}

class RandomNumberFetcher: RandomNumberFetcherProtocol {
    
    // We are going to handle all errors the same way for the purposes of this app
    static let genericError = NSError(domain: "com.storypointscalculator", code: 1, userInfo: nil)
    
    private let url = URL(string: "https://api.random.org/json-rpc/1/invoke")!
    private let httpClient: HttpClient
    private let apiVersion = "2.0"
    private let apiMethod = "generateIntegers"
    private let id = 0
    private let apiKey = "ec06126f-4d95-4757-abcb-74eebc65fcdb"
    
    struct RequestBody: Codable, Equatable {
        
        struct Params: Codable, Equatable {
            let apiKey: String
            let n: Int
            let min: Int
            let max: Int
            let replacement: Bool
            let base: Int
        }
        
        let jsonrpc: String
        let method: String
        let id: Int
        let params: Params
    }
    
    struct Response: Codable {
        struct Result: Codable {
            struct Random: Codable {
                let data: [Int]
            }
            let random: Random
        }
        
        let result: Result
    }
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func fetchRandomNumber(completion: @escaping (Int?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json-rpc", forHTTPHeaderField: "Content-Type")
        let body = RequestBody(jsonrpc: apiVersion,
                               method: apiMethod,
                               id: id,
                               params: .init(apiKey: apiKey,
                                             n: 1,
                                             min: 1,
                                             max: 10,
                                             replacement: true,
                                             base: 10))
        
        request.httpBody = try? JSONEncoder().encode(body)
        
        let dataTask = httpClient.dataTask(with: request) { (data, response, error) in
            guard
                let responseData = data,
                let response = try? JSONDecoder()
                    .decode(Response.self, from: responseData),
                let number = response.result.random.data.first
            else {
                completion(nil, RandomNumberFetcher.genericError)
                return
            }
            
            completion(number, nil)
        }
        
        dataTask.resume()
    }
}
