//
//  SpecificVideo.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

struct SpecificVideo {
    let id: Int
    let width: Int
    let height: Int
    let user: User
    let files: [SpecificVideoFile]
}

struct SpecificVideoFile {
    let id: Int
    let width: Int
    let height: Int
    let quality: String
    let fileType: String
    let url: String
}
