//
//  NetworkProvider.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

protocol Networkable {

    func load<Target: Requestable>(
        _ target: Target,
        _ completion: @escaping (Result<Target.Response, Error>) -> Void
    )
}

final class DefaultNetworkProvider: Networkable {
    
    private let session: URLSession
    
    init(session: URLSession = .init(configuration: .default)) {
        self.session = session
    }
    
    func load<Target: Requestable>(
        _ target: Target,
        _ completion: @escaping (Result<Target.Response, Error>) -> Void
    ) {
        
        let task = session.dataTask(with: target.urlRequest) { data, response, error in
            
            if let error = error as? URLError {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(ProviderValidationError.notHTTPResponse))
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                let receivedCode = response.statusCode
                completion(.failure(ProviderValidationError.badHTTPResponse(receivedCode)))
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
