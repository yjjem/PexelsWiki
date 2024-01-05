//
//  FilterOptions.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


struct FilterOptions {
    let orientation: ContentOrientation
    let size: ContentSize
    
    init(orientation: ContentOrientation = .landscape, size: ContentSize = .large) {
        self.orientation = orientation
        self.size = size
    }
}
