//
//  Requestable.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

protocol Requestable {
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var path: String { get }
    var queries: [String: String] { get }
    var headers: [String: String] { get }
    var method: HTTPMethod { get }
}

extension Requestable {
    
    private var url: URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path = path
        components?.queryItems = queries.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = components?.url else {
            fatalError()
        }
        
        return url
    }
    
    var urlRequest: URLRequest {
        let urlRequest = URLRequest(url: url, method: method, headers: headers)
        return urlRequest
    }
}
