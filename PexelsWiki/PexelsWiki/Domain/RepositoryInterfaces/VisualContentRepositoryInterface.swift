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
        _ completion: @escaping (Result<CuratedPhotosPage, Error>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func searchPhotos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<SearchedPhotosPage, Error>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func fetchPhotoForID(
        _ id: Int,
        _ completion: @escaping (Result<SpecificPhoto, Error>) -> Void
    ) -> Cancellable?
    
    // MARK: Video
    
    @discardableResult
    func searchVideos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<SearchedVideosPage, Error>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func fetchVideoForID(
        _ id: Int,
        _ completion: @escaping (Result<SpecificVideo, Error>) -> Void
    ) -> Cancellable?
}
