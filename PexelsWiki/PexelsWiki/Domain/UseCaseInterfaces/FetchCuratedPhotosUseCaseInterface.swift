//
//  FetchCuratedPhotosUseCaseInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol FetchCuratedPhotosUseCaseInterface {
    associatedtype SearchParameters
    
    @discardableResult
    func fetchCuratedPhotoPage(
        _ parameters: SearchParameters,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) -> Cancellable?
}


