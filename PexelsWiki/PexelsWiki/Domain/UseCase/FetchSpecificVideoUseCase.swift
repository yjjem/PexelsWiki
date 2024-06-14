//
//  FetchSpecificVideoUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol FetchSpecificVideoUseCase {
    func fetchVideoBy(
        id: Int,
        _ completion: @escaping (Result<SpecificVideo, Error>) -> Void
    ) -> Cancellable?
}
