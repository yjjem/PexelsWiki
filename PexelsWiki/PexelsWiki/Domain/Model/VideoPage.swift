//
//  VideoPage.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


struct VideoPage: Hashable {
    let page: Int
    let hasNext: Bool
    let videos: [VideoResource]
}
