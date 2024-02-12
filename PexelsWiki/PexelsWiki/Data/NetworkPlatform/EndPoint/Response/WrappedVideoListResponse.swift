//
//  VideoListResponse.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

struct WrappedVideoListResponse: Decodable {
    let page: Int
    let url: String
    let videos: [VideoResource]
    let nextPage: String?
}

struct VideoResource: Decodable, Hashable {
    let id: Int
    let user: User
    let tags: [String]
    let image: String
    let duration: Int
    let videoFiles: [VideoFile]
}

struct VideoFile: Decodable, Hashable {
    let width: Int
    let height: Int
    let link: String
}

struct User: Decodable, Hashable {
    let name: String
    let url: String
}
