//
//  PexelsSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

final class SearchNavigatorViewModel {
    
    // MARK: Property(s)
    
    private var query: String = ""
    private let categoryItems: [RecommendedCategory] = RecommendedCategory.allCases
    
    // MARK: Function(s)
    
    func updateQuery(_ newQuery: String) {
        self.query = newQuery
    }
    
    func currentQuery() -> String {
        return query
    }
    
    func categoryItem(for indexPath: IndexPath) -> RecommendedCategory {
        return categoryItems[indexPath.row]
    }
    
    func shuffledCategories() -> [RecommendedCategory] {
        return categoryItems.shuffled()
    }
}
