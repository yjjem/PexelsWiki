//
//  FetchCuratedPhotosPort.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol CuratedPhotosPort {
    @discardableResult
    func fetchCuratedPhotos(
        _ completion: @escaping (Result<[CuratedPhoto], DiscoverCuratedPhotosUseCaseError>) -> Void
    ) -> Cancellable?
    
    func reset()
}
