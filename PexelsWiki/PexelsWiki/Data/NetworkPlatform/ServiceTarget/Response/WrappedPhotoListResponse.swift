//
//  WrappedPhotoListResponse.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

struct WrappedPhotoListResponse: Decodable {
    let page: Int
    let perPage: Int
    let photos: [PhotoResource]
    let totalPages: Int
    let nextPage: String?
}

struct PhotoResource: Hashable, Decodable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let photographerURL: String
    let averageColor: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, url, photographer
        case photographerURL = "photographer_url"
        case averageColor = "avg_color"
        case description = "alt"
    }
}
