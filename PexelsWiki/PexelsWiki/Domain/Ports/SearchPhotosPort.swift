//
//  SearchPhotosPort.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol SearchPhotosPort {
    @discardableResult
    func searchPhotos(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<SearchedPhotosPage, Error>) -> Void
    ) -> Cancellable?
}
