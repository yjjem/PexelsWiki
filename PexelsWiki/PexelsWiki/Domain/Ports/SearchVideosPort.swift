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
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<SearchedVideosPage, Error>) -> Void
    ) -> Cancellable?
}
