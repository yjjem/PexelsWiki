//
//  SearchVideosPort.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol SearchVideosPort {
    @discardableResult
    func searchVideos(
        query: String,
        orientation: String,
        size: String,
        _ completion: @escaping (Result<SearchedVideosResult, SearchVideosUseCaseError>) -> Void
    ) -> Cancellable?
}
