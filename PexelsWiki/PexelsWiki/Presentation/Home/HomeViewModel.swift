//
//  HomeViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

final class HomeViewModel {
    
    // MARK: Variable(s)
    
    var loadedCuratedPhotos: (([PhotoResource]) -> Void)?
    
    private let useCase: CuratedPhotosUseCaseInterface
    private var page: Int = 1
    private var pageSize: PageSize = .small
    private var hasNext: Bool = false
    private var isLoading: Bool = false
    
    init(useCase: CuratedPhotosUseCaseInterface) {
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func fetchCuratedPhotosPage() {
        useCase.fetchCuratedPhotoPage(
            page: page,
            perPage: pageSize.itemsPerPage
        ) { [weak self] response in
            
            if let self, case .success(let photoPage) = response {
                self.page = photoPage.page + 1
                self.hasNext = photoPage.hasNext
                self.loadedCuratedPhotos?(photoPage.photos)
                self.isLoading = false
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
        pageSize = .small
        hasNext = false
        fetchCuratedPhotosPage()
    }
}
