//
//  CuratedPhotosUseCaseInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

protocol CuratedPhotosUseCaseInterface {
    associatedtype SearchParameters
    
    @discardableResult
    func fetchCuratedPhotoPage(
        _ parameters: SearchParameters,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) -> Cancellable?
}


