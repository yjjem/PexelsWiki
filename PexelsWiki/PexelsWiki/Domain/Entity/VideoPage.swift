//
//  VideoPage.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


struct VideoPage {
    let page: Int
    let hasNext: Bool
    let totalResults: Int
    let videos: [VideoBundle]
    
    func nextPage() -> Int {
        return page + 1
    }
}

struct VideoBundle {     
    let id: Int
    let user: User
    let duration: Int
    let tags: [String]
    let previewURL: String
    let resolution: ContentResolution
}
 
