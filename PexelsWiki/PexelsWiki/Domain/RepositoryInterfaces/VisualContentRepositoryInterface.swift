//
//  VisualContentRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

protocol VisualContentRepositoryInterface {
    
    // MARK: Photo
    
    @discardableResult
    func fetchCuratedPhotos(
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func searchPhotos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func fetchPhotoForID(
        _ id: Int,
        _ completion: @escaping (Result<PhotoBundle, Error>) -> Void
    ) -> Cancellable?
    
    // MARK: Video
    
    @discardableResult
    func fetchPopularVideos(
        minWidth: Int,
        minHeight: Int,
        minDuration: Int,
        maxDuration: Int,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func searchVideos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func fetchVideoForID(
        _ id: Int,
        _ completion: @escaping (Result<VideoBundle, Error>) -> Void
    ) -> Cancellable?
}
