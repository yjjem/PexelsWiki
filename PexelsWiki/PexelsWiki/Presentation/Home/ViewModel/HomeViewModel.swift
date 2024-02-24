//
//  HomeViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

final class HomeViewModel {
    
    // MARK: Binding(s)
    
    var loadedHomeContentViewModelList: (([HomeContentCellViewModel]) -> Void)?
    
    // MARK: Property(s)
    
    private var isLoading: Bool = false
    private var hasNext: Bool = false
    private var page: Int = 1
    
    private let useCase: CuratedPhotosUseCase
    private let maxItemsPerPage: Int
    
    init(maxItemsPerPage: Int = 15, useCase: CuratedPhotosUseCase) {
        self.maxItemsPerPage = maxItemsPerPage
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func fetchCuratedPhotosPage() {
        guard isLoading == false else { return }
        isLoading = true
        let searchValues = CuratedPhotosUseCase.SearchParameters(
            page: page,
            perPage: maxItemsPerPage
        )
        useCase.fetchCuratedPhotoPage(searchValues) { [weak self] response in
            if case .success(let photoPage) = response {
                let homeCellViewModels = photoPage.photos.map {
                    HomeContentCellViewModel(
                        userName: $0.user.name,
                        userProfileURL: $0.user.profileURL,
                        imageTitle: $0.title,
                        imageID: $0.id,
                        imageURL: $0.variations.large,
                        imageWidth: $0.resolution.width,
                        imageHeight: $0.resolution.height,
                        resolutionString: $0.resolution.toString()
                    )
                }
                self?.loadedHomeContentViewModelList?(homeCellViewModels)
                self?.updatePageValues(page: photoPage.nextPage(), hasNext: photoPage.hasNext)
                self?.isLoading = false
            }
        }
    }
    
    func fetchNextPage() {
        guard hasNext == true else { return }
        fetchCuratedPhotosPage()
    }
    
    func resetPage() {
        page = 1
        hasNext = false
        fetchCuratedPhotosPage()
    }
    
    // MARK: Private Function(s)
    
    private func updatePageValues(page: Int, hasNext: Bool) {
        self.page = page
        self.hasNext = hasNext
    }
}
