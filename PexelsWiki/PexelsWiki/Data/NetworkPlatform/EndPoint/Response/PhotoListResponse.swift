//
//  WrappedPhotoListResponse.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


struct PhotoListResponse: Decodable {
    let page: Int
    let perPage: Int
    let photos: [PhotoResourceResponse]
    let totalResults: Int
    let previousPage: String?
    let nextPage: String?
    
    enum CodingKeys: String, CodingKey {
        case page, perPage, photos, totalResults, nextPage
        case previousPage = "prevPage"
    }
}

struct PhotoResourceResponse: Decodable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let imageSources: ImageSourcesResponse
    let photographer: String
    let photographerURL: String
    let photographerID: Int
    let averageColor: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, url, photographer
        case photographerID = "photographerId"
        case photographerURL = "photographerUrl"
        case averageColor = "avgColor"
        case imageSources = "src"
        case title = "alt"
    }
}

struct ImageSourcesResponse: Decodable {
    let original: String
    let large: String
    let large2x: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
}
