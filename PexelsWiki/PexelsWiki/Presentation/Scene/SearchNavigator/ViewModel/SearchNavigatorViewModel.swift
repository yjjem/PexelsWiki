//
//  PexelsSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


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
    
    func shuffledCategories() -> [RecommendedCategory] {
        return categoryItems.shuffled()
    }
}
