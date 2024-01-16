//
//  CuratedPhotosUseCaseInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

protocol CuratedPhotosUseCaseInterface {
    
    func fetchCuratedPhotoPage(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<PhotoPage, Error>) -> Void
    )
}
