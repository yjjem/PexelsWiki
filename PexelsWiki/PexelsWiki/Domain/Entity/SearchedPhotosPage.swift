//
//  SearchedPhotosPage.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

struct SearchedPhotosPage: Page {
    typealias Item = SearchedPhoto
    let page: Int
    let hasNext: Bool
    let totalResults: Int
    let items: [SearchedPhoto]
}
