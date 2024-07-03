//
//  SearchPhotosPort.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol SearchPhotosPort {
    @discardableResult
    func searchPhotos(
        _ parameters: SearchPhotosParameter,
        _ completion: @escaping (Result<SearchPhotosResult, SearchPhotosUseCaseError>) -> Void
    ) -> Cancellable?
}
