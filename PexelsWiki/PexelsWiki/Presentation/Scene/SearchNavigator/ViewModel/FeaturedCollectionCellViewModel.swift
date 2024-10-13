//
//  FeaturedCollectionCellViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


struct FeaturedCollectionCellViewModel: Hashable {
    let identifier: String
    let title: String
    let description: String
    let totalItems: Int
    
    init(identifier: String, title: String, description: String, totalItems: Int) {
        self.identifier = identifier
        self.title = title.trimmingCharacters(in: .whitespaces)
        self.description = description.trimmingCharacters(in: .whitespaces)
        self.totalItems = totalItems
    }
}
