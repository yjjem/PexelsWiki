//
//  VideoListResponse.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


struct VideoListResponse: Decodable {
    let page: Int
    let url: String
    let videoResponses: [VideoResponse]
    let nextPage: String?
    let previousPage: String?
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, url, videoResponses, nextPage, totalResults
        case previousPage = "prevPage"
    }
}
