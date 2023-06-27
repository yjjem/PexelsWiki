//
//  SearchFilterViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

final class SearchFilterViewModel {
    var selectedOrientation: ContentOrientation = .landscape
    var selectedSize: ContentSize = .large
    
    init(selectedOrientation: ContentOrientation, selectedSize: ContentSize) {
        self.selectedOrientation = selectedOrientation
        self.selectedSize = selectedSize
    }
}
