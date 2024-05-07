//
//  FetchPhotoUseCaseInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol FetchSpecificPhotoUseCase {
    func fetchPhoto(
        id: Int,
        _ completion: @escaping (Result<PhotoBundle, Error>) -> Void
    ) -> Cancellable?
}
