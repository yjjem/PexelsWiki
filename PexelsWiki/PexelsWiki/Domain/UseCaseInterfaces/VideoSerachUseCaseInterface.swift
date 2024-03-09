//
//  VideoSerachUseCaseInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

protocol VideoSearchUseCaseInterface {
    associatedtype SearchParameters
    
    @discardableResult
    func search(
        _ parameters: SearchParameters,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    ) -> Cancellable?
}
