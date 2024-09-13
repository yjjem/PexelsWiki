//
//  CollectionResourceResponse.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

struct CollectionsResponse: Decodable {
    let collectionResources: [CollectionResourceResponse]
    let page: Int
    let nextPage: String?
    let totalResults: Int
}

struct CollectionResourceResponse: Decodable {
    let id: String
    let title: String
    let description: String
    let isPrivate: Bool
    let mediaCount: Int
    let photosCount: Int
    let videosCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case isPrivate = "private"
        case mediaCount
        case photosCount
        case videosCount
    }
}
