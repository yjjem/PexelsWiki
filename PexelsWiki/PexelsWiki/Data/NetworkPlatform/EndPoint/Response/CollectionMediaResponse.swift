//
//  CollectionMediasResponse.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

struct CollectionMediaResponse: Decodable {
    
    let page: Int
    let nextPage: String
    let totalResultsCount: Int
    
    let id: String
    let mediaResponses: [MediaResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaResponses
        case page
        case nextPage
        case totalResultsCount = "totalResults"
    }
}
