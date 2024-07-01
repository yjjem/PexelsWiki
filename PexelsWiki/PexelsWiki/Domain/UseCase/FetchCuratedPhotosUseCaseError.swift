//
//  FetchCuratedPhotosUseCaseError.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


enum FetchCuratedPhotosUseCaseError: Error {
    case endOfPage
    case failedFetching
    case invalidPage
}
