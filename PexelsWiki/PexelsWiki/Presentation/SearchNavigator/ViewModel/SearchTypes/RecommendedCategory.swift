//
//  Category.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


enum RecommendedCategory: String, CaseIterable {
    case business, flowers, food, forest, landscape, nature, summer

    var capitalizedName: String {
        return rawValue.capitalized
    }
    
    var imageName: String {
        return rawValue
    }
}
