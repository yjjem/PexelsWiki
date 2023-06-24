//
//  PexelsSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

final class PexelsSearchViewModel {
    
    var searchQuery: String = ""
    var searchContentType: ContentType = .image
    
    let categoryItems: [Category] = [
        Category(name: "business"),
        Category(name: "flowers"),
        Category(name: "forest"),
        Category(name: "summer"),
        Category(name: "landscape"),
        Category(name: "black and white"),
        Category(name: "nature"),
        Category(name: "food"),
    ]
}
