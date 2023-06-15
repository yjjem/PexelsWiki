//
//  ContentDetails.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


enum ContentOrientation {
    case landscape
    case portrait
    case square
    
    var name: String {
        switch self {
        case .landscape: return "landscape"
        case .portrait: return "portrait"
        case .square: return "square"
        }
    }
}

enum ContentSize {
    case large
    case medium
    case small
    
    var name: String {
        switch self {
        case .large: return "large"
        case .medium: return "medium"
        case .small: return "small"
        }
    }
}
