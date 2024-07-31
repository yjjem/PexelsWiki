//
//  SearchVideosUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol SearchVideosUseCase {
    @discardableResult
    func search(
        _ parameters: SearchVideosCommand,
        _ completion: @escaping (Result<SearchedVideosResult, SearchVideosUseCaseError>) -> Void
    ) -> Cancellable?
}
