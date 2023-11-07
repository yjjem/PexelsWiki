//
//  PexelsSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

final class SearchNavigatorViewModel {
    
    var searchQuery: String = ""
    var searchContentType: ContentType = .image
    
    let categoryItems: [RecommendedCategory] = RecommendedCategory.allCases
}
