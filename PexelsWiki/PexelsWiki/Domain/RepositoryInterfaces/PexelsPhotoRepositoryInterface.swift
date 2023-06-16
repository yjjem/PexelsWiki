//
//  PexelsPhotoRepositoryInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

protocol PexelsPhotoRepositoryInterface {
    
    func loadCuratedPhotos(
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, RepositoryError>) -> Void
    )
    
    func searchPhotos(
        query: String,
        orientation: ContentOrientation,
        size: ContentSize,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, RepositoryError>) -> Void
    )
}
