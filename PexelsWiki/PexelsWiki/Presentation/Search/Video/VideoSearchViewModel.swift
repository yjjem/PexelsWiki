//
//  VideoSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

final class VideoSearchViewModel {
    
    // MARK: Variable(s)
    
    var query: String = ""
    var orientation: ContentOrientation = .landscape
    var size: ContentSize = .small
    
    var loadedVideoResources: (([VideoResource]) -> Void)?
    
    private var page: Int = 1
    private var pageSize: PageSize = .small
    private var hasNext: Bool = false
    private var isLoading: Bool = false
    private var contentType: ContentOrientation = .landscape
    
    private let useCase: VideoSearchUseCaseInterface
    
    init(useCase: VideoSearchUseCaseInterface) {
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func fetchSearchResults() {
        isLoading = true
        useCase.search(
            query: query,
            orientation: orientation.name,
            size: size.name,
            page: page,
            perPage: pageSize.itemsPerPage
        ) { [weak self] response in
            
            if let self, case .success(let videoPage) = response {
                self.isLoading = false
                self.page = videoPage.page
                self.hasNext = videoPage.hasNext
                self.loadedVideoResources?(videoPage.videos)
            }
        }
    }
    
    func apply(filter options: FilterOptions) {
        orientation = options.orientation
        size = options.size
    }
    
    func fetchNextPage() {
        if isLoading {
            return
        }
        
        if hasNext {
            page += 1
            fetchSearchResults()
        }
    }
    
    func resetPage() {
        page = 1
        pageSize = .small
        hasNext = false
        fetchSearchResults()
    }
}
