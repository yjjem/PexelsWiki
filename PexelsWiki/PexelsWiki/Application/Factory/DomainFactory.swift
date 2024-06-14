//
//  DomainFactory.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.

struct DomainFactory {
    
    // MARK: Property(s)
    
    private let dataFactory: DataFactory
    
    // MARK: Initializer(s)
    
    init(dataFactory: DataFactory) {
        self.dataFactory = dataFactory
    }
    
    // MARK: UseCase(s)
    
    func makeCuratedPhotosUseCase() -> FetchCuratedPhotosUseCase {
        return CuratedPhotosService(port: dataFactory.makeVisualContentRepository())
    }
    
    func makePhotoSearchUseCase() -> SearchPhotosUseCase {
        return SearchPhotosService(port: dataFactory.makeVisualContentRepository())
    }
    
    func makeFetchSinglePhotoUseCase() -> FetchSpecificPhotoUseCase {
        return SpecificPhotoService(port: dataFactory.makeVisualContentRepository())
    }
    
    func makeVideoSearchUseCase() -> SearchVideosUseCase {
        return SearchVideosService(port: dataFactory.makeVisualContentRepository())
    }
    
    func makeFetchSingleVideoUseCase() -> FetchSpecificVideoUseCase {
        return SpecificVideoService(port: dataFactory.makeVisualContentRepository())
    }
}
