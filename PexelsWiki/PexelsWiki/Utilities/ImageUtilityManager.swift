//
//  ImageUtilityManager.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

struct ImageUtilityManager {
    
    // MARK: Shared Property(s)
    
    private static let thumbnailCache: NSCache<NSString, UIImage> = {
        let thumbnailCache = NSCache<NSString, UIImage>()
        thumbnailCache.totalCostLimit = 200 * 1024 * 1024
        return thumbnailCache
    }()
    
    // MARK: Property(s)
    
    private let configuration: ImageUtilityManagerConfiguration
    private let imageCache = NSCache<NSString, UIImage>()
    private let imageFetchSession: URLSession
    
    init(configuration: ImageUtilityManagerConfiguration) {
        self.configuration = configuration
        self.imageFetchSession = URLSession(configuration: configuration.sessionConfiguration)
        self.imageCache.totalCostLimit = configuration.cacheCapacity
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func requestImage(
        for urlString: String,
        shouldCache: Bool = true,
        _ completion: @escaping (UIImage?) -> Void
    ) -> Cancellable? {
        
        let imageCacheKey = NSString(string: urlString)
        
        if shouldCache {
            if let objectFromCache = imageCache.object(forKey: imageCacheKey) {
                completion(objectFromCache)
                return nil
            }
        }
        
        let task = self.fetchImage(urlString) { image in
            guard let image else {
                completion(configuration.errorImage)
                return
            }
            
            if shouldCache {
                imageCache.setObject(image, forKey: imageCacheKey)
            }
            
            completion(image)
            
        }
        task?.resume()
        return task
    }
    
    @discardableResult
    func requestThumbnailImage(
        urlString: String,
        desiredThumbnailSize: CGSize,
        _ completion: @escaping (UIImage?) -> Void
    ) -> Cancellable? {
        return requestImage(for: urlString) { image in
            
            let thumbnailCacheKey = NSString(string: urlString)
            
            if let cachedThumbnail = ImageUtilityManager.thumbnailCache
                .object(forKey: thumbnailCacheKey) {
                completion(cachedThumbnail)
                return
            }
            
            image?.prepareThumbnail(of: desiredThumbnailSize) { thumbnail in
                if let thumbnail {
                    ImageUtilityManager.thumbnailCache.setObject(
                        thumbnail,
                        forKey: thumbnailCacheKey
                    )
                }
                completion(thumbnail)
            }
        }
    }
    
    // MARK: Private Function(s)
    
    private func fetchImage(
        _ urlString: String,
        _ completion: @escaping (UIImage?) -> Void
    ) -> URLSessionDataTask? {
        
        guard let imageURL = URL(string: urlString) else {
            completion(nil)
            return nil
        }
        
        return imageFetchSession.dataTask(
            with: URLRequest(url: imageURL)
        ) { data, response, error in
            
            guard error == nil,
                  response?.mimeType == "image/jpeg",
                  let httpResponse = response as? HTTPURLResponse,
                  (200..<300) ~= httpResponse.statusCode
            else {
                completion(nil)
                return
            }
            
            if let data {
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }
    }
}
