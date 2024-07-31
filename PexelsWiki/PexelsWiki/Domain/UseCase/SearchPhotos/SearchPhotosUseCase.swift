//
//  SearchPhotosUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol SearchPhotosUseCase {
    @discardableResult
    func search(
        _ command: SearchPhotosCommand,
        _ completion: @escaping (Result<SearchPhotosResult, SearchPhotosUseCaseError>) -> Void
    ) -> Cancellable?
}
