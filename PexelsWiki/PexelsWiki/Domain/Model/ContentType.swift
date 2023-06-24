//
//  ContentType.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


enum ContentType: CaseIterable {
    case image
    case video
    
    var name: String {
        switch self {
        case .image: return "Image"
        case .video: return "Video"
        }
    }
}
