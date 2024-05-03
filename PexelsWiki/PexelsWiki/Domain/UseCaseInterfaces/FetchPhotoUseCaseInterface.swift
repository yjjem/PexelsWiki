//
//  FetchPhotoUseCaseInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol FetchPhotoUseCaseInterface {
    func fetchPhoto(
        id: Int,
        _ completion: @escaping (Result<PhotoBundle, Error>) -> Void
    ) -> Cancellable?
}
