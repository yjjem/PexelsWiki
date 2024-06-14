//
//  FetchCuratedPhotosUseCaseInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol FetchCuratedPhotosUseCase {
    associatedtype SearchParameters
    
    @discardableResult
    func fetchCuratedPhotoPage(
        _ parameters: SearchParameters,
        _ completion: @escaping (Result<CuratedPhotosPage, Error>) -> Void
    ) -> Cancellable?
}


