//
//  Pagination.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class Pagination {
    
    // MARK: Type(s)
    
    struct PaginationInformation {
        let page: Int
        let itemsPerPage: Int
    }
    
    // MARK: Property(s)
    
    private var page: Int
    private let itemsPerPage: Int
    
    init(initialPageIndex: Int = 1, itemsPerPage: Int) {
        self.page = initialPageIndex
        self.itemsPerPage = itemsPerPage
    }
    
    // MARK: Function(s)
    
    func nextPage() {
        self.page += 1
    }
    
    func resetPage() {
        self.page = 1
    }
    
    func currentPaginationInformation() -> PaginationInformation {
        return PaginationInformation(page: page, itemsPerPage: itemsPerPage)
    }
}

