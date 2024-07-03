//
//  SpeficicPhotoPort.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol SpecificPhotoPort {
    @discardableResult
    func fetchPhotoForID(
        _ id: Int,
        _ completion: @escaping (Result<SpecificPhoto, FetchSpecificPhotoUseCaseError>) -> Void
    ) -> Cancellable?
}
