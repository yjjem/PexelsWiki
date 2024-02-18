//
//  VisualContentRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

final class VisualContentRepository: VisualContentRepositoryInterface {
    
    // MARK: Property(s)
    
    private let provider: Networkable
    private let apiFactory: APIFactory
    
    // MARK: Initializer(s)
    
    init(provider: Networkable, apiFactory: APIFactory) {
        self.provider = provider
        self.apiFactory = apiFactory
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func fetchCuratedPhotos(
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) -> Cancellable? {
        let endPoint = apiFactory.makeCuratedPhotosEndPoint(page: page, perPage: perPage)
        return provider.send(request: endPoint.makeURLRequest()) { result in
            let mappedResult = result
                .flatMap { endPoint.decode(data: $0) }
                .map { $0.toPhotoPage() }
            completion(mappedResult)
        }
    }
    
    @discardableResult
    func searchPhotos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) -> Cancellable? {
        let endPoint = apiFactory.makeSearchPhotosEndPoint(
            query: query,
            orientation: orientation,
            size: size,
            page: page,
            perPage: perPage
        )
        return provider.send(request: endPoint.makeURLRequest()) { result in
            let mappedResult = result
                .flatMap { endPoint.decode(data: $0) }
                .map { $0.toPhotoPage() }
            completion(mappedResult)
        }
    }
    
    @discardableResult
    func fetchPopularVideos(
        minWidth: Int,
        minHeight: Int,
        minDuration: Int,
        maxDuration: Int,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    ) -> Cancellable? {
        let endPoint = apiFactory.makePopularVideosEndPoint(
            minWidth: minWidth,
            minHeight: minHeight,
            minDuration: minDuration,
            maxDuration: maxDuration,
            page: page,
            perPage: perPage
        )
        return provider.send(request: endPoint.makeURLRequest()) { result in
            let mappedResult = result
                .flatMap { endPoint.decode(data: $0) }
                .map { $0.toVideoPage() }
            completion(mappedResult)
        }
    }
    
    @discardableResult
    func searchVideos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    ) -> Cancellable? {
        let endPoint = apiFactory.makeSearchVideosEndPoint(
            query: query,
            orientation: orientation,
            size: size,
            page: page,
            perPage: perPage
        )
        return provider.send(request: endPoint.makeURLRequest()) { result in
            let mappedResult = result
                .flatMap { endPoint.decode(data: $0) }
                .map { $0.toVideoPage() }
            completion(mappedResult)
        }
    }
}
