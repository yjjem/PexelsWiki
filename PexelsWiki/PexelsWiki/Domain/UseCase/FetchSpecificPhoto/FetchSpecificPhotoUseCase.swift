//
//  FetchPhotoUseCaseInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol FetchSpecificPhotoUseCase {
    @discardableResult
    func fetchPhoto(
        id: Int,
        _ completion: @escaping (Result<SpecificPhoto, FetchSpecificPhotoUseCaseError>) -> Void
    ) -> Cancellable?
}
