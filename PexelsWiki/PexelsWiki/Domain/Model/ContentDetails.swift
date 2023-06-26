//
//  ContentDetails.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


enum ContentOrientation: CaseIterable {
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
    
    var orderIndex: Int {
        switch self {
        case .landscape: return 0
        case .portrait: return 1
        case .square: return 2
        }
    }
}

enum ContentSize: CaseIterable {
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
    
    var orderIndex: Int {
        switch self {
        case .large: return 0
        case .medium: return 1
        case .small: return 2
        }
    }
}
