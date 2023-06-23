//
//  PexelsPhotoServiceTarget.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

enum PexelsPhotoServiceTarget {
    case searchPhotos(
        query: String,
        orientation: ContentOrientation,
        size: ContentSize,
        page: Int,
        perPage: Int
    )
    case curatedPhotos(
        page: Int,
        perPage: Int
    )
}

extension PexelsPhotoServiceTarget: Requestable {
    typealias Response = WrappedPhotoListResponse
    
    var baseURL: URL { return URL(string: "https://api.pexels.com")! }
    
    var path: String {
        switch self {
        case .searchPhotos: return "/v1/search"
        case .curatedPhotos: return "/v1/curated"
        }
    }
    
    var queries: [String: String] {
        switch self {
        case let .searchPhotos(query, orientation, size, page, perPage):
            return [
                "query": query,
                "orientation": orientation.name,
                "size": size.name,
                "page": String(page),
                "per_page": String(perPage)
            ]
        case let .curatedPhotos(page, perPage):
            return [
                "page": String(page),
                "per_page": String(perPage)
            ]
        }
    }
    
    var headers: [String: String] {
        return [
            "Authorization": MainBundle.apiKey
        ]
    }
    
    var method: HTTPMethod {
        return .get
    }
}
