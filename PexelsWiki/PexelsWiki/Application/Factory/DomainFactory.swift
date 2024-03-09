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
    
    func makeCuratedPhotosUseCase() -> CuratedPhotosUseCase {
        return CuratedPhotosUseCase(repository: dataFactory.makeVisualContentRepository())
    }
    
    func makePhotoSearchUseCase() -> PhotoSearchUseCase {
        return PhotoSearchUseCase(repository: dataFactory.makeVisualContentRepository())
    }
    
    func makeFetchSinglePhotoUseCase() -> FetchSinglePhotoUseCase {
        return FetchSinglePhotoUseCase(repository: dataFactory.makeVisualContentRepository())
    }
    
    func makeVideoSearchUseCase() -> VideoSearchUseCase {
        return VideoSearchUseCase(repository: dataFactory.makeVisualContentRepository())
    }
    
    func makeFetchSingleVideoUseCase() -> FetchSingleVideoUseCase {
        return FetchSingleVideoUseCase(repository: dataFactory.makeVisualContentRepository())
    }
}
