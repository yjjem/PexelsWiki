//
//  PhotoSearchUseCaseInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

protocol PhotoSearchUseCaseInterface {
    associatedtype SearchParameters
    
    func search(
        _ parameters: SearchParameters,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    )
}
