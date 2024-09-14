//
//  PhotoResponse.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

struct PhotoResponse: Decodable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let photographerProfileURL: String
    let photographerIdentifier: Int
    let source: PhotoSourceResponse
    let averageColor: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case url
        case photographer
        case photographerProfileURL = "photographerUrl"
        case photographerIdentifier = "photographerId"
        case source = "src"
        case averageColor = "avgColor"
        case title = "alt"
    }
}
