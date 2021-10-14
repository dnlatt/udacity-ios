//
//  URLSessionProtocol.swift
//  LattSports
//
//  Created by dnlatt on 28/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Network
import Foundation

protocol URLSessionDataTaskProtocol {
  func resume()
  func cancel()
}

protocol URLSessionProtocol {
  func dataTask(
    with request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask
}

extension URLSession : URLSessionProtocol{}
extension URLSessionDataTask : URLSessionDataTaskProtocol{}
