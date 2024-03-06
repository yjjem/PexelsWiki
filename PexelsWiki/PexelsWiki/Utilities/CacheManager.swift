//
//  CacheManager.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation
import UIKit

final class CacheManager {
    private let memoryCapacity = 200 * 1024 * 1024 // 200 MB
    private let diskCapacity = 500 * 1024 * 1024 // 500 MB
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
