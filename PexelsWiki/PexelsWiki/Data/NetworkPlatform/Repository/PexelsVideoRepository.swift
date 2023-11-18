//
//  PexelsVideoRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class PexelsVideoRepository: PexelsVideoRepositoryInterface {
    
    private let provider: Networkable
    
    init(provider: Networkable) {
        self.provider = provider
    }
    
    func loadPopularVideos(
        minWidth: Int,
        minHeight: Int,
        minDuration: Int,
        maxDuration: Int,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    ) {
        let target: PexelsVideoServiceTarget = .popularVideos(
            minWidth: minWidth,
            minHeight: minHeight,
            minDuration: minDuration,
            maxDuration: maxDuration,
            page: page,
            perPage: perPage
        )
        
        provider.load(target) { result in
            let response = result
                .map { $0.toVideoPage() }
                .mapError { $0 as Error }
            completion(response)
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
        let target: PexelsVideoServiceTarget = .searchVideos(
            query: query,
            orientation: orientation,
            size: size,
            page: page,
            perPage: perPage
        )
        
        provider.load(target) { result in
            let response = result
                .map { $0.toVideoPage() }
                .mapError { $0 as Error }
            completion(response)
        }
    }
}
