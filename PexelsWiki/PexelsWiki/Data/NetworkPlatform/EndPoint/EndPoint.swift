//
//  EndPoint.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

struct EndPoint<Entity: Decodable>: Requestable {
    typealias Response = Entity
    
    let baseURL: URL
    let path: String
    let queries: [String : String]
    let headers: [String : String]
    let method: HTTPMethod
    
    init(
        baseURL: URL,
        path: String, 
        queries: [String : String] = [:],
        headers: [String : String] = [:],
        method: HTTPMethod
    ) {
        self.baseURL = baseURL
        self.path = path
        self.queries = queries
        self.headers = headers
        self.method = method
    }
}

extension EndPoint {
    func decode(data: Data) -> Result<Response, Error> {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let data = try jsonDecoder.decode(Response.self, from: data)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}

