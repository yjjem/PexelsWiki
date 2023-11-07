//
//  ContentType.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


enum ContentType: String, CaseIterable {
    case image
    case video
    
    var name: String {
        return rawValue.capitalized
    }
}
