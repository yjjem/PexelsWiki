//
//  WrappedPhotoListResponse.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


struct PhotoListResponse: Decodable {
    let page: Int
    let perPage: Int
    let photoResponses: [PhotoResponse]
    let totalResults: Int
    let previousPage: String?
    let nextPage: String?
    
    enum CodingKeys: String, CodingKey {
        case page, perPage, totalResults, nextPage
        case photoResponses = "photos"
        case previousPage = "prevPage"
    }
}
