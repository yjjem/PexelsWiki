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
    let totalPages: Int?
    let nextPage: String?
}

struct PhotoResource: Hashable, Decodable {
    let id: Int
    let width: Int
    let height: Int
    let url: [String: String]
    let photographer: String
    let photographerURL: String
    let averageColor: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, photographer
        case photographerURL = "photographerUrl"
        case averageColor = "avgColor"
        case description = "alt"
        case url = "src"
    }
}
