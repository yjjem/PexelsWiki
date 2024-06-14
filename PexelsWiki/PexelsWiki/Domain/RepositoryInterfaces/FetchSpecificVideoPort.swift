//
//  VisualContentRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

protocol CuratedPhotosPort {
    @discardableResult
    func fetchCuratedPhotos(
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<CuratedPhotosPage, Error>) -> Void
    ) -> Cancellable?
}

protocol SearchPhotosPort {
    @discardableResult
    func searchPhotos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<SearchedPhotosPage, Error>) -> Void
    ) -> Cancellable?
}

protocol FetchSpecificPhotoPort {
    @discardableResult
    func fetchPhotoForID(
        _ id: Int,
        _ completion: @escaping (Result<SpecificPhoto, Error>) -> Void
    ) -> Cancellable?
}

protocol SearchVideosPort {
    @discardableResult
    func searchVideos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<SearchedVideosPage, Error>) -> Void
    ) -> Cancellable?
}

protocol FetchSpecificVideoPort {
    @discardableResult
    func fetchVideoForID(
        _ id: Int,
        _ completion: @escaping (Result<SpecificVideo, Error>) -> Void
    ) -> Cancellable?
}

protocol VisualContentRepositoryInterface: CuratedPhotosPort,
                                            SearchPhotosPort,
                                            FetchSpecificPhotoPort,
                                            SearchVideosPort,
                                            FetchSpecificVideoPort { }
