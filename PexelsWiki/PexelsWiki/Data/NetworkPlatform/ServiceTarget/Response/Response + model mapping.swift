//
//  Response + model mapping.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

extension WrappedVideoListResponse {
    
    var hasNextPage: Bool {
        return nextPage != nil ? true: false
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
    
    var hasNextPage: Bool {
        return nextPage != nil ? true: false
    }
    
    func toPhotoPage() -> PhotoPage {
        return PhotoPage(
            page: page,
            hasNext: hasNextPage,
            photos: photos
        )
    }
}
