//
//  CuratedPhotosPage.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


struct CuratedPhotosPage: Pageable {
    typealias Item = CuratedPhoto
    let page: Int
    let hasNext: Bool
    let totalResults: Int
    let items: [CuratedPhoto]
}
