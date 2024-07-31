//
//  DiscoverCuratedPhotosUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol DiscoverCuratedPhotosUseCase {
    @discardableResult
    func fetchCuratedPhotos(
        _ completion: @escaping (Result<[CuratedPhoto], DiscoverCuratedPhotosUseCaseError>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func reload(
        _ completion: @escaping (Result<[CuratedPhoto], DiscoverCuratedPhotosUseCaseError>) -> Void
    ) -> Cancellable?
}
