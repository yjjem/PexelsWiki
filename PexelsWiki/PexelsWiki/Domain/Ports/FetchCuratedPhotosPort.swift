//
//  FetchCuratedPhotosPort.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol CuratedPhotosPort {
    @discardableResult
    func fetchCuratedPhotos(
        page: Int,
        perPage: Int,
        _ completion: @escaping (Result<CuratedPhotosPage, Error>) -> Void
    ) -> Cancellable?
}
