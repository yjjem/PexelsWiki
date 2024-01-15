//
//  VisualContentRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

protocol VisualContentRepositoryInterface {
    
    func fetchCuratedPhotos(
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    )
    
    func searchPhotos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    )
    
    func fetchPopularVideos(
        minWidth: Int,
        minHeight: Int,
        minDuration: Int,
        maxDuration: Int,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    )
    
    func searchVideos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    )
}
