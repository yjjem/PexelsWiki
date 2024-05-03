//
//  SearchVideosUseCaseInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol SearchVideosUseCaseInterface {
    associatedtype SearchParameters
    
    @discardableResult
    func search(
        _ parameters: SearchParameters,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    ) -> Cancellable?
}
