//
//  MediaLoadManager.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

protocol Cancellable {
    func cancel()
}

extension URLSessionDataTask: Cancellable { }

enum ImageLoadManager {
    
    private static let imageCache = URLCache(
        memoryCapacity: 200.megaBytes,
        diskCapacity: 500.megaBytes
    )
    
    static func fetchCachedImageDataElseLoad(
        urlString: String,
        _ completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask? {
        
        guard let url = URL(string: urlString) else { return nil }
        
        let request = URLRequest(url: url)
        
        if let cached = imageCache.cachedResponse(for: request) {
            completion(.success(cached.data))
            return nil
        } else {
            return loadImageData(request: request, completion)
        }
    }
    
    private static func loadImageData(
        request: URLRequest,
        _ completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        
        let uiQueue = DispatchQueue.main
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error {
                uiQueue.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let data, let response {
                
                if imageCache.cachedResponse(for: request) == nil {
                    let cached = CachedURLResponse(response: response, data: data)
                    imageCache.storeCachedResponse(cached, for: request)
                }
                
                uiQueue.async {
                    completion(.success(data))
                }
            }
        }
        
        task.resume()
        
        return task
    }
}
