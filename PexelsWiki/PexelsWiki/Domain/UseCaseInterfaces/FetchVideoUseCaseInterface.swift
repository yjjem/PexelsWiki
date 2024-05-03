//
//  FetchVideoUseCaseInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

protocol FetchSingleVideoUseCaseInterface {
    func fetchVideoBy(
        id: Int,
        _ completion: @escaping (Result<VideoBundle, Error>) -> Void
    ) -> Cancellable?
}
