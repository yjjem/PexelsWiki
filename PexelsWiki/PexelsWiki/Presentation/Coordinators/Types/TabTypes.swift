//
//  TabTypes.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


enum TabTypes: String {
    case home
    case search
    case collections
    
    var title: String {
        return rawValue.capitalized
    }
    
    var defaultIconName: String {
        switch self {
        case .home: "house"
        case .search: "magnifyingglass"
        case .collections: "sparkles.rectangle.stack"
        }
    }
    
    var selectedIconName: String {
        switch self {
        case .home: "house.fill"
        case .search: "magnifyingglass"
        case .collections: "sparkles.rectangle.stack"
        }
    }
}
