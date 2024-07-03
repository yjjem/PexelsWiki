//
//  FetchCuratedPhotosUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol FetchCuratedPhotosUseCase {
    @discardableResult
    func fetchCuratedPhotos(
        _ completion: @escaping (Result<[CuratedPhoto], FetchCuratedPhotosUseCaseError>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func reload(
        _ completion: @escaping (Result<[CuratedPhoto], FetchCuratedPhotosUseCaseError>) -> Void
    ) -> Cancellable?
}
