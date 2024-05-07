//
//  SearchedVideo.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


struct SearchedVideo {
    let id: Int
    let user: User
    let thumbnail: String
    let duration: Int
    let width: Int
    let height: Int
    let files: [SearchedVideoFile]
}
