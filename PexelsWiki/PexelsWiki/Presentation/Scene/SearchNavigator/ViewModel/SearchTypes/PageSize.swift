//
//  PageSize.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

enum PageSize {
    case small
    case medium
    case large
    
    var itemsPerPage: Int {
        switch self {
        case .small: return 15
        case .medium: return 30
        case .large: return 50
        }
    }
}
