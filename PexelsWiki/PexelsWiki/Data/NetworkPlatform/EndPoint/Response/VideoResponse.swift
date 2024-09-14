//
//  VideoResponse.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

struct VideoResponse: Decodable {
    let id: Int
    let width: Int?
    let height: Int?
    let duration: Int
    let sourceURL: String
    let thumbnailURL: String
    let userResponse: UserResponse
    let videoFilesResponse: [VideoFileResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case duration
        case sourceURL = "url"
        case thumbnailURL = "image"
        case userResponse
        case videoFilesResponse
    }
}

struct VideoFileResponse: Decodable {
    let id: Int
    let quality: String
    let fileType: String
    let width: Int?
    let height: Int?
    let fps: Int
    let link: String
}

struct UserResponse: Decodable {
    let id: Int
    let name: String
    let url: String
}
