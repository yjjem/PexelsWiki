//
//  PexelsSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class SearchNavigatorViewModel {
    
    // MARK: Property(s)
    
    private var query: String = ""
    
    // MARK: Function(s)
    
    func updateQuery(_ newQuery: String) {
        self.query = newQuery
    }
    
    func currentQuery() -> String {
        return query
    }
    
    func shuffledCategories() -> [RecommendedCategoryCellViewModel] {
        return RecommendedCategoryCellViewModel.allCases.shuffled()
    }
}
