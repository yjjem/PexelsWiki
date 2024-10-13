//
//  HTTPMethod.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

enum HTTPMethod {
    case get
    case post
    case patch
    case delete
    
    var name: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        }
    }
}
