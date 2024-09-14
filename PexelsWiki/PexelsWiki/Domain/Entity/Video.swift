//
//  Video.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

struct Video {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let thumbnailURL: String
    let duration: Int
    let user: User
    let videoFiles: [VideoFile]
}

struct VideoFile {
    let id: Int
    let quality: String
    let fileType: String
    let width: Int
    let height: Int
    let fps: Int
    let hostURL: String
    
}
