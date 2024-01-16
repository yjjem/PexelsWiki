//
//  Response + model mapping.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

extension WrappedVideoListResponse {
    
    private var hasNextPage: Bool {
        return nextPage != nil
    }
    
    func toVideoPage() -> VideoPage {
        return VideoPage(
            page: page,
            hasNext: hasNextPage,
            videos: videos
        )
    }
}

extension WrappedPhotoListResponse {
    
    private var hasNextPage: Bool {
        return nextPage != nil
    }
    
    func toPhotoPage() -> PhotoPage {
        return PhotoPage(
            page: page,
            hasNext: hasNextPage,
            photos: photos
        )
    }
}
