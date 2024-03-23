//
//  ImageUtilityManagerConfiguration.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import UIKit

struct ImageUtilityManagerConfiguration {
    
    static let defaultConfiguration = ImageUtilityManagerConfiguration(
        errorImage: UIImage(systemName: "xmark.square.fill"),
        cacheCapacity: 30 * 1024 * 1024,
        cacheMaxItems: .zero
    )
    
    let sessionConfiguration: URLSessionConfiguration
    let errorImage: UIImage?
    let cacheCapacity: Int
    let cacheMaxItems: Int
    
    init(
        sessionConfiguration: URLSessionConfiguration = .default,
        errorImage: UIImage?,
        cacheCapacity: Int,
        cacheMaxItems: Int
    ) {
        self.sessionConfiguration = sessionConfiguration
        self.errorImage = errorImage
        self.cacheCapacity = cacheCapacity
        self.cacheMaxItems = cacheMaxItems
    }
}
