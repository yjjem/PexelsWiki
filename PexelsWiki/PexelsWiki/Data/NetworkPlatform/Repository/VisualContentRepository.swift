//
//  VisualContentRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

final class VisualContentRepository: VisualContentRepositoryInterface {
    
    // MARK: Property(s)
    
    private let provider: Networkable
    private let baseURL: URL = URL(string: "https://api.pexels.com")!
    
    // MARK: Initializer(s)
    
    init(provider: Networkable) {
        self.provider = provider
    }
    
    // MARK: Function(s)
    
    func fetchCuratedPhotos(
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) {
        let endPoint = EndPoint<WrappedPhotoListResponse>(
            baseURL: baseURL,
            path: "/v1/curated",
            queries: ["page": String(page), "perPage": String(perPage)],
            headers: ["Authorization": MainBundle.apiKey],
            method: .get
        )
        provider.send(request: endPoint.urlRequest) { result in
            let mappedResult = result
                .flatMap { endPoint.decode(data: $0) }
                .map { $0.toPhotoPage() }
            completion(mappedResult)
        }
    }
    
    func searchPhotos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) {
        let endPoint = EndPoint<WrappedPhotoListResponse>(
            baseURL: baseURL,
            path: "/v1/search",
            queries: [
                "query": query,
                "orientation": orientation,
                "size": size,
                "page": String(page),
                "perPage": String(perPage)
            ],
            headers: ["Authorization": MainBundle.apiKey],
            method: .get
        )
        provider.send(request: endPoint.urlRequest) { result in
            let mappedResult = result
                .flatMap { endPoint.decode(data: $0) }
                .map { $0.toPhotoPage() }
            completion(mappedResult)
        }
    }
    
    func fetchPopularVideos(
        minWidth: Int,
        minHeight: Int,
        minDuration: Int,
        maxDuration: Int,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    ) {
        let endPoint = EndPoint<WrappedVideoListResponse>(
            baseURL: baseURL,
            path: "/videos/popular",
            queries: [
                "minWidth": String(minWidth),
                "minHeight": String(minHeight),
                "minDuration": String(minDuration),
                "maxDuration": String(maxDuration),
                "page": String(page),
                "perPage": String(perPage),
            ],
            headers: ["Authorization": MainBundle.apiKey],
            method: .get
        )
        provider.send(request: endPoint.urlRequest) { result in
            let mappedResult = result
                .flatMap { endPoint.decode(data: $0) }
                .map { $0.toVideoPage() }
            completion(mappedResult)
        }
    }
    
    func searchVideos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    ) {
        let endPoint = EndPoint<WrappedVideoListResponse>(
            baseURL: baseURL,
            path: "/videos/search",
            queries: [
                "query": query,
                "orientation": orientation,
                "size": size,
                "page": String(page),
                "perPage": String(perPage)],
            headers: ["Authorization": MainBundle.apiKey],
            method: .get
        )
        provider.send(request: endPoint.urlRequest) { result in
            let mappedResult = result
                .flatMap { endPoint.decode(data: $0) }
                .map { $0.toVideoPage() }
            completion(mappedResult)
        }
    }
}
