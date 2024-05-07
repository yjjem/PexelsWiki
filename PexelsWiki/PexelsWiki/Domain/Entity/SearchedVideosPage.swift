//
//  SearchedVideoPage.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


struct SearchedVideosPage: Pageable {
    typealias Item = SearchedVideo
    let page: Int
    let hasNext: Bool
    let totalResults: Int
    let items: [SearchedVideo]
}
