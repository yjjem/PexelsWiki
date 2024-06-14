//
//  FetchCuratedPhotosUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol FetchCuratedPhotosUseCase {
    @discardableResult
    func fetchCuratedPhotoPage(
        _ parameters: FetchCuratedPhotosParameter,
        _ completion: @escaping (Result<CuratedPhotosPage, Error>) -> Void
    ) -> Cancellable?
}
