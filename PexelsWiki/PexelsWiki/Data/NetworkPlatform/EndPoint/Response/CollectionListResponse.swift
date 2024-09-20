//
//  CollectionListResponse.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

struct CollectionListResponse: Decodable {
    let collections: [CollectionResponse]
    let page: Int
    let nextPage: String?
    let totalResults: Int
}
