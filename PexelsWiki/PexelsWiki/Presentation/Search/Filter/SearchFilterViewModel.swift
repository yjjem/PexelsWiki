//
//  SearchFilterViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

final class SearchFilterViewModel {
    
    enum Option: CaseIterable {
        case orientation
        case size
    }
    
    // MARK: Property(s)
    
    private var selectedOrientation: ContentOrientation = .landscape
    private var selectedSize: ContentSize = .large
    
    // MARK: Initializer(s)
    
    init(selectedOrientation: ContentOrientation, selectedSize: ContentSize) {
        self.selectedOrientation = selectedOrientation
        self.selectedSize = selectedSize
    }
    
    // MARK: Function(s)
    
    func currentFilterOptions() -> FilterOptions {
        return FilterOptions(orientation: selectedOrientation, size: selectedSize)
    }
    
    func selectOptions(at indexPath: IndexPath) {
        let selectedOptionType = Option.allCases[indexPath.section]
        let optionIndex = indexPath.row
        
        switch selectedOptionType {
        case .orientation:
            selectedOrientation = ContentOrientation.allCases[optionIndex]
        case .size:
            selectedSize = ContentSize.allCases[optionIndex]
        }
    }
}
