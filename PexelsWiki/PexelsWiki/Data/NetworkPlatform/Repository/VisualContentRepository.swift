//
//  VisualContentRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


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
        _ completion: @escaping (Result<[CuratedPhoto], Error>) -> Void
    ) -> Cancellable? {
        let endPoint = apiFactory.makeCuratedPhotosEndPoint(page: page, perPage: perPage)
        return provider.send(request: endPoint.makeURLRequest()) { result in
            let mappedResult = result
                .flatMap { endPoint.decode(data: $0) }
                .map { $0.toCuratedPhotos() }
            completion(mappedResult)
        }
    }
    
    @discardableResult
    func fetchPhotoForID(
        _ id: Int,
        _ completion: @escaping (Result<SpecificPhoto, Error>) -> Void
    ) -> Cancellable? {
        let endPoint = apiFactory.makePhotoEndPoint(id: id)
        return provider.send(request: endPoint.makeURLRequest()) { result in
            let mappedResult = result
                .flatMap { endPoint.decode(data: $0) }
                .map { $0.toPhotoBundle() }
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
        _ completion: @escaping (Result<SearchedVideosPage, Error>) -> Void
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
                .map { $0.toSearchedVideosPage() }
            completion(mappedResult)
        }
    }
    
    @discardableResult
    func fetchVideoForID(
        _ id: Int,
        _ completion: @escaping (Result<SpecificVideo, Error>) -> Void
    ) -> Cancellable? {
        let endPoint = apiFactory.makeVideoEndPoint(id: id)
        return provider.send(request: endPoint.makeURLRequest()) { result in
            let mappedResult = result
                .flatMap { endPoint.decode(data: $0) }
                .map { $0.toSpecificVideo() }
            completion(mappedResult)
        }
    }
}
