//
//  PexelsVideoRepositoryInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

protocol PexelsVideoRepositoryInterface {
    
    func loadPopularVideos(
        minWidth: Int,
        minHeight: Int,
        minDuration: Int,
        maxDuration: Int,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<Item, RepositoryError>) -> Void
    )
    
    func searchVideos(
        query: String,
        orientation: ContentOrientation,
        size: ContentSize,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<Item, RepositoryError>) -> Void
    )
}
