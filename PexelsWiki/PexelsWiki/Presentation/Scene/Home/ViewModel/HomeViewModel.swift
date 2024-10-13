//
//  HomeViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class HomeViewModel {
    
    // MARK: Binding(s)
    
    var loadedHomeContentViewModelList: (([HomeContentCellViewModel]?) -> Void)?
    
    // MARK: Property(s)
    
    private let useCase: DiscoverCuratedPhotosUseCase
    
    init(useCase: DiscoverCuratedPhotosUseCase) {
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func onNeedItems() {
        useCase.fetchCuratedPhotos { [weak self] response in
            switch response {
            case .success(let curatedPhotos):
                let cellViewModels = curatedPhotos.toHomeContentCellViewModel()
                self?.loadedHomeContentViewModelList?(cellViewModels)
            case .failure(_):
                self?.loadedHomeContentViewModelList?(nil)
            }
        }
    }
    
    func onRefresh() {
        useCase.reload { [weak self] response in
            switch response {
            case .success(let curatedPhotos):
                let cellViewModels = curatedPhotos.toHomeContentCellViewModel()
                self?.loadedHomeContentViewModelList?(cellViewModels)
            case .failure(_):
                self?.loadedHomeContentViewModelList?(nil)
            }
        }
    }
}
