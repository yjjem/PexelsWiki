//
//  HomeViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

final class HomeViewModel {
    typealias Hello = String
    
    // MARK: Variable(s)
    
    var loadedCuratedPhotos: (([PhotoResource]) -> Void)?
    
    private let useCase: PexelsPhotoUseCaseInterface
    private var page: Int = 1
    private var pageSize: PageSize = .small
    private var hasNext: Bool = false
    private var isLoading: Bool = false
    
    init(useCase: PexelsPhotoUseCaseInterface) {
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func loadCuratedPhotosPage() {
        useCase.loadCuratedPhotoPage(
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
