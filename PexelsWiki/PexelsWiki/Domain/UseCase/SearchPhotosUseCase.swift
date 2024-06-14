//
//  SearchPhotosUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol SearchPhotosUseCase {
    @discardableResult
    func search(
        _ parameters: SearchPhotosParameter,
        _ completion: @escaping (Result<SearchedPhotosPage, Error>) -> Void
    ) -> Cancellable?
}
