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
    
    private func makeURL() -> URL? {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0, value: $1) }
        components?.path = path
        return components?.url
    }
    
    func makeURLRequest() -> URLRequest? {
        guard let url = makeURL() else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.name
        request.allHTTPHeaderFields = headers
        return request
    }
}
