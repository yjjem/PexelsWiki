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
    
    private let imageCache: NSCache = {
        let imageCache = NSCache<NSString, UIImage>()
        imageCache.totalCostLimit = 100 * 1024 * 1024
        return imageCache
    }()
    
    private let imageFetchSession: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.waitsForConnectivity = true
        return URLSession(configuration: sessionConfiguration)
    }()
    
    // MARK: Function(s)
    
    @discardableResult
    func requestImage(
        for urlString: String,
        shouldCache: Bool = true,
        _ completion: @escaping (UIImage?) -> Void
    ) -> Cancellable? {
        
        let cacheKey = NSString(string: urlString)
        
        if shouldCache, let imageFromCache = imageCache.object(forKey: cacheKey) {
            completion(imageFromCache)
            return nil
        }
        
        let task = fetchImage(urlString) { optionalImage in
            optionalImage?.prepareForDisplay { optionalPreparedImage in
                guard let preparedImage = optionalPreparedImage else {
                    completion(nil)
                    return
                }
                
                if shouldCache {
                    imageCache.setObject(
                        preparedImage,
                        forKey: cacheKey,
                        cost: calculateCacheCostFor(preparedImage: preparedImage)
                    )
                }
                
                completion(preparedImage)
            }
        }
        task?.resume()
        return task
    }
    
    @discardableResult
    func thumbnail(
        for urlString: String,
        toFit frameToFit: CGRect,
        cropStrategy: ImageCropper.CropStrategy,
        _ completion: @escaping (UIImage?) -> Void
    ) -> Cancellable? {
        
        let cacheKey = NSString(string: urlString)
        
        if let thumbnailFromCache = ImageUtilityManager.thumbnailCache.object(forKey: cacheKey) {
            completion(thumbnailFromCache)
            return nil
        }
        
        let task = fetchImage(urlString) { optionalImage in
            guard let fetchedImage = optionalImage else {
                completion(nil)
                return
            }
            
            let croppedImageElseOriginal = ImageCropper(
                sourceImage: fetchedImage,
                strategy: cropStrategy,
                frameToFit: frameToFit
            ).crop()
            
            croppedImageElseOriginal?.prepareThumbnail(of: frameToFit.size) {
                optionalPreparedThumbnail in
                
                guard let preparedThumbnail = optionalPreparedThumbnail else {
                    completion(nil)
                    return
                }
                
                ImageUtilityManager.thumbnailCache.setObject(
                    preparedThumbnail,
                    forKey: cacheKey,
                    cost: calculateCacheCostFor(preparedImage: preparedThumbnail)
                )
                
                completion(optionalPreparedThumbnail)
            }
        }
        task?.resume()
        return task
    }
    
    // MARK: Private Function(s)
    
    private func calculateCacheCostFor(preparedImage: UIImage) -> Int {
        let preparedImageSize = preparedImage.size
        let areaValue = preparedImageSize.width * preparedImageSize.height
        let bytesPerPixel = (preparedImage.cgImage?.bitsPerPixel ?? 1) * 1/4
        let preparedImageCost = Int(areaValue *  preparedImage.scale) * bytesPerPixel
        return preparedImageCost
    }
    
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
            
            guard let data else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: data))
        }
    }
}
