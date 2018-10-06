//
//  HttpClient.swift
//  testing_the_waters_of_ios
//
//  Created by Kostas Kremizas on 06/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import Foundation

protocol HttpClient {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: HttpClient {}
