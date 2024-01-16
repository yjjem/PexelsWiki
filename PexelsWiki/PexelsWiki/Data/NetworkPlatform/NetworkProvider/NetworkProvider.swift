//
//  NetworkProvider.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

protocol Networkable {

    func send(request: URLRequest?, _ completion: @escaping (Result<Data, Error>) -> Void)
}

final class DefaultNetworkProvider: Networkable {
    
    private let session: URLSession
    
    init(session: URLSession = .init(configuration: .default)) {
        self.session = session
    }
    
    func send(request: URLRequest?, _ completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let request else { return }
        
        let task = session.dataTask(with: request) { data, response, error in
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
                completion(.success(data))
            }
        }
        
        task.resume()
    }
}
