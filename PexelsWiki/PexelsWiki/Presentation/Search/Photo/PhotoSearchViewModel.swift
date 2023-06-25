//
//  PhotoSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class PhotoSearchViewModel {
    
    var loadedPhotoResources: (([PhotoResource]) -> Void)?
    
    var query: String = ""
    var orientation: ContentOrientation = .landscape
    var size: ContentSize = .small
    
    private var page: Int = 1
    private var pageSize: PageSize = .small
    private var hasNext: Bool = false
    private var isLoading: Bool = false
    private var contentType: ContentOrientation = .landscape
    
    private let useCase: PexelsPhotoSearchUseCaseInterface
    
    init(useCase: PexelsPhotoSearchUseCaseInterface) {
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
            
            response.onComplete { [weak self] photoPage in
                self?.isLoading = false
                self?.page = photoPage.page
                self?.hasNext = photoPage.hasNext
                self?.loadedPhotoResources?(photoPage.photos)
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
