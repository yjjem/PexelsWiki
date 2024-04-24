//
//  CacheManager.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation
import UIKit

final class CacheManager {
    private let memoryCapacity = 20 * 1024 * 1024 // 20 MB
    private let diskCapacity = 50 * 1024 * 1024 // 50 MB
    private let cacheDirectory: URL? = {
        return try? FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }()
    
    lazy var urlCache = URLCache(
        memoryCapacity: memoryCapacity,
        diskCapacity: diskCapacity,
        directory: cacheDirectory
    )
}
