//
//  FeaturedCollectionCellViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


struct FeaturedCollectionCellViewModel: Hashable {
    let title: String
    let description: String
    let totalItems: Int
    
    init(title: String, description: String, totalItems: Int) {
        self.title = title.trimmingCharacters(in: .whitespaces)
        self.description = description.trimmingCharacters(in: .whitespaces)
        self.totalItems = totalItems
    }
}
