//
//  URLRequest + parameters.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

extension URLRequest {
    
    init(url: URL, method: HTTPMethod, headers: [String: String]) {
        self.init(url: url)
        self.httpMethod = method.name
        headers.forEach { key, value in
            self.addValue(value, forHTTPHeaderField: key)
        }
    }
}
