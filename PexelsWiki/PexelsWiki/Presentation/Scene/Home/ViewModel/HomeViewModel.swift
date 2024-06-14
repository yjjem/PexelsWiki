//
//  HomeViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

final class HomeViewModel {
    
    // MARK: Binding(s)
    
    var loadedHomeContentViewModelList: (([HomeContentCellViewModel]?) -> Void)?
    
    // MARK: Property(s)
    
    private var isLoading: Bool = false
    private var hasNext: Bool = false
    private var page: Int = 1
    
    private let useCase: FetchCuratedPhotosUseCase
    private let maxItemsPerPage: Int
    
    init(maxItemsPerPage: Int = 15, useCase: FetchCuratedPhotosUseCase) {
        self.maxItemsPerPage = maxItemsPerPage
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func fetchCuratedPhotosPage() {
        guard isLoading == false else { return }
        isLoading = true
        let searchValues = FetchCuratedPhotosParameter(
            page: page,
            perPage: maxItemsPerPage
        )
        useCase.fetchCuratedPhotoPage(searchValues) { [weak self] response in
            switch response {
            case .success(let curatedPhotosPage):
                let homeCellViewModels = curatedPhotosPage.items.map {
                    HomeContentCellViewModel(
                        userName: $0.user.name,
                        userProfileURL: $0.user.profileURL,
                        imageTitle: $0.title,
                        imageID: $0.id,
                        imageURL: $0.sources.large,
                        imageWidth: $0.width,
                        imageHeight: $0.height,
                        resolutionString: "\($0.width) x \($0.height)"
                    )
                }
                self?.loadedHomeContentViewModelList?(homeCellViewModels)
                self?.updatePageValues(page: curatedPhotosPage.page + 1, hasNext: curatedPhotosPage.hasNext)
                self?.isLoading = false
            case .failure(_):
                self?.loadedHomeContentViewModelList?(nil)
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
