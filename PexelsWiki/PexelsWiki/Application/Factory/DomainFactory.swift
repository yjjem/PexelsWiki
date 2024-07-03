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
        return CuratedPhotosService(port: dataFactory.makeCuratedPhotosPort())
    }
    
    func makePhotoSearchUseCase() -> SearchPhotosUseCase {
        return SearchPhotosService(port: dataFactory.makeSearchPhotosPort())
    }
    
    func makeFetchSinglePhotoUseCase() -> FetchSpecificPhotoUseCase {
        return SpecificPhotoService(port: dataFactory.makeSpecificPhotoPort())
    }
    
    func makeVideoSearchUseCase() -> SearchVideosUseCase {
        return SearchVideosService(port: dataFactory.makeSearchVideosPort())
    }
    
    func makeFetchSingleVideoUseCase() -> FetchSpecificVideoUseCase {
        return SpecificVideoService(port: dataFactory.makeVisualContentRepository())
    }
}
