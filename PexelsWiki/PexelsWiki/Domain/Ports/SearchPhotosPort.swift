//
//  SearchPhotosPort.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol SearchPhotosPort {
    @discardableResult
    func searchPhotos(
        _ parameters: SearchPhotosCommand,
        _ completion: @escaping (Result<SearchPhotosResult, SearchPhotosUseCaseError>) -> Void
    ) -> Cancellable?
}
