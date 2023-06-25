//
//  VideoSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

final class VideoSearchViewModel {
    
    var loadedVideoResources: (([VideoResource]) -> Void)?
    
    var query: String = ""
    var orientation: ContentOrientation = .landscape
    var size: ContentSize = .small
    
    private var page: Int = 1
    private var pageSize: PageSize = .small
    private var hasNext: Bool = false
    private var isLoading: Bool = false
    private var contentType: ContentOrientation = .landscape
    
    private let useCase: PexelsVideoSearchUseCaseInterface
    
    init(useCase: PexelsVideoSearchUseCaseInterface) {
        self.useCase = useCase
    }
    
    func loadSearchResults() {
        isLoading = true
        useCase.search(
            query: query,
            orientation: orientation,
            size: size,
            page: page,
            perPage: pageSize.itemsPerPage
        ) { response in
            
            response.onComplete { [weak self] videoPage in
                self?.isLoading = false
                self?.page = videoPage.page
                self?.hasNext = videoPage.hasNext
                self?.loadedVideoResources?(videoPage.videos)
            }
        }
    }
    
    func loadNextPage() {
        if isLoading {
            return
        }
        
        if hasNext {
            page += 1
            loadSearchResults()
        }
    }
    
    func resetPage() {
        page = 1
        pageSize = .small
        hasNext = false
        loadSearchResults()
    }
}
