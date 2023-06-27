//
//  HomeViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

final class HomeViewModel {
    
    // MARK: Variable(s)
    
    private let useCase: PexelsPhotoUseCaseInterface
    private var page: Int = 1
    private var pageSize: PageSize = .small
    private var hasNext: Bool = false
    private var isLoading: Bool = false
    
    var loadedCuratedPhotos: (([PhotoResource]) -> Void)?
    
    init(useCase: PexelsPhotoUseCaseInterface) {
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func loadCuratedPhotosPage() {
        useCase.loadCuratedPhotoPage(page: page, perPage: pageSize.itemsPerPage) { response in
            response.onComplete { [weak self] photoPage in
                self?.page = photoPage.page + 1
                self?.hasNext = photoPage.hasNext
                self?.loadedCuratedPhotos?(photoPage.photos)
                self?.isLoading = false
            }
        }
    }
    
    func loadNextPage() {
        guard isLoading == false else { return }
        
        if hasNext {
            page += 1
            isLoading = true
            loadCuratedPhotosPage()
        }
    }
    
    func resetPage() {
        page = 1
        pageSize = .small
        hasNext = false
        loadCuratedPhotosPage()
    }
}
