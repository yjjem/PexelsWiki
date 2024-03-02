//
//  ContentDetails.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


enum ContentOrientation: String, CaseIterable {
    case landscape
    case portrait
    case square
    
    var name: String {
        return rawValue
    }
    
    var capitalizedName: String {
        return rawValue.capitalized
    }
    
    var orderIndex: Int {
        switch self {
        case .landscape: return 0
        case .portrait: return 1
        case .square: return 2
        }
    }
}

enum ContentSize: String, CaseIterable {
    case large
    case medium
    case small
    
    var name: String {
        return rawValue
    }
    
    var capitalizedName: String {
        return rawValue.capitalized
    }
    
    var orderIndex: Int {
        switch self {
        case .large: return 0
        case .medium: return 1
        case .small: return 2
        }
    }
}
