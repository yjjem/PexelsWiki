//
//  VideoListResponse.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

struct VideoListResponse: Decodable {
    let page: Int
    let url: String
    let videos: [VideoResourceResponse]
    let nextPage: String?
    let previousPage: String?
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, url, videos, nextPage, totalResults
        case previousPage = "prevPage"
    }
}

struct VideoResourceResponse: Decodable {
    let id: Int
    let width: Int
    let height: Int
    let tags: [String]
    let url: String
    let image: String
    let duration: Int
    let userResponse: UserResponse
    let videoFiles: [VideoFileResponse]
    let videoPictures: [VideoPictureResponse]
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, tags, url, image, duration, videoFiles, videoPictures
        case userResponse = "user"
    }
}

struct VideoPictureResponse: Decodable {
    let id: Int
    let url: String
    let index: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case url = "picture"
        case index = "nr"
    }
}

struct VideoFileResponse: Decodable {
    let width: Int
    let height: Int
    let link: String
}

struct UserResponse: Decodable {
    let id: Int
    let name: String
    let url: String
}
