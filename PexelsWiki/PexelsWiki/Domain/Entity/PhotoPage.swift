//
//  PhotoPage.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


struct PhotoPage {
    let page: Int
    let hasNext: Bool
    let totalResults: Int
    let photos: [PhotoBundle]
    
    func nextPage() -> Int {
        return page + 1
    }
}

struct PhotoBundle {
    let id: Int
    let user: User
    let title: String
    let variations: PhotoVariations
    let resolution: ContentResolution
}

struct PhotoVariations {
    let original: String
    let large: String
    let large2x: String
    let medium: String
    let portrait: String
    let landscape: String
    let tiny: String
}
