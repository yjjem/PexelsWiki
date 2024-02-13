//
//  HomeViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

final class HomeViewModel {

    // MARK: Binding(s)
    
    var loadedCuratedPhotos: (([PhotoResource]) -> Void)?
    
    // MARK: Property(s)
    
    private var isLoading: Bool = false
    private var hasNext: Bool = false
    private var page: Int = 1
    
    private let pageSize: PageSize = .small
    private let useCase: CuratedPhotosUseCase
    
    init(useCase: CuratedPhotosUseCase) {
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func fetchCuratedPhotosPage() {
        let searchValues = CuratedPhotosUseCase.SearchParameters(
            page: page,
            perPage: pageSize.itemsPerPage
        )
        useCase.fetchCuratedPhotoPage(searchValues) { [weak self] response in
            if case .success(let photoPage) = response {
                self?.page = photoPage.page + 1
                self?.hasNext = photoPage.hasNext
                self?.loadedCuratedPhotos?(photoPage.photos)
                self?.isLoading = false
            }
        }
    }
    
    func fetchNextPage() {
        guard isLoading == false else { return }
        
        if hasNext {
            page += 1
            isLoading = true
            fetchCuratedPhotosPage()
        }
    }
    
    func resetPage() {
        page = 1
        hasNext = false
        fetchCuratedPhotosPage()
    }
}
