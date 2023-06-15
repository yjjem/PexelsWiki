//
//  PexelsVideoServiceTarget.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

enum PexelsVideoServiceTarget {
    case searchVideos(
        query: String,
        orientation: ContentOrientation,
        size: ContentSize,
        page: Int,
        perPage: Int
    )
    case popularVideos(
        minWidth: Int,
        minHeight: Int,
        minDuration: Int,
        maxDuration: Int,
        page: Int,
        perPage: Int
    )
}

extension PexelsVideoServiceTarget: Requestable {
    typealias Response = WrappedVideoListResponse
    
    var baseURL: URL { return URL(string: "https://api.pexels.com")! }
    
    var path: String {
        switch self {
        case .searchVideos: return "/videos/search"
        case .popularVideos: return "/videos/popular"
        }
    }
    
    var queries: [String: String] {
        switch self {
        case let .searchVideos(query, orientation, size, page, perPage):
            return [
                "query": query,
                "orientation": orientation.name,
                "size": size.name,
                "page": String(page),
                "per_page": String(perPage)
            ]
        case let .popularVideos(minWidth, minHeight, minDuration, maxDuration, page, perPage):
            return [
                "min_width": String(minWidth),
                "min_height": String(minHeight),
                "min_duration": String(minDuration),
                "max_duration": String(maxDuration),
                "page": String(page),
                "per_page": String(perPage)
            ]
        }
    }
    
    var headers: [String: String] {
        return [
            "Authentication": "key"
        ]
    }
    
    var method: HTTPMethod {
        return .get
    }
}
