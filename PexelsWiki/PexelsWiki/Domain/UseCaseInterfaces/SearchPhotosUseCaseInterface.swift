//
//  SearchPhotosUseCaseInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol SearchPhotosUseCaseInterface {
    associatedtype SearchParameters
    
    @discardableResult
    func search(
        _ parameters: SearchParameters,
        _ completion: @escaping (Result<SearchedPhotosPage, Error>) -> Void
    ) -> Cancellable?
}
