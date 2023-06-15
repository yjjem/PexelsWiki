//
//  NetworkProvider.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

struct Item: Decodable {

}

protocol Networkable {

    func load<Target: Requestable>(
        _ target: Target,
        _ completion: @escaping (Result<Target.Response, NetworkError>) -> Void
    )
}

final class DefaultNetworkProvider: Networkable {
    
    private let session: URLSession
    
    init(session: URLSession = .init(configuration: .default)) {
        self.session = session
    }
    
    func load<Target>(
        _ target: Target,
        _ completion: @escaping (Result<Target.Response, NetworkError>) -> Void
    ) where Target : Requestable {
        
        let task = session.dataTask(with: target.urlRequest) { data, response, error in
            
            if let error = error as? URLError {
                completion(.failure(.targetRequestFailed(reason: error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.notHTTPResponse))
                return
            }
            
            guard response.codeIsNot(200) else {
                completion(.failure(.badHTTPResponse(code: response.statusCode)))
                return
            }
            
            if let data {
                let decodeResult = data.decode(to: Target.Response.self)
                completion(decodeResult)
            }
        }
        
        task.resume()
    }
}
