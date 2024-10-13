//
//  PhotoSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class PhotoListViewModel {
    
    // MARK: Binding(s)
    
    var loadedPhotoContentCellViewModels: (([PhotoContentCellViewModel]) -> Void)?
    
    // MARK: Property(s)
    
    var totalItemsFound: Int = 0
    
    private var query: String = ""
    
    private let orientation: ContentOrientation = .landscape
    private let useCase: SearchPhotosUseCase
    
    init(query: String?, useCase: SearchPhotosUseCase) {
        self.useCase = useCase
        self.query = query ?? ""
    }
    
    // MARK: Function(s)
    
    func onNeedItems() {
        let searchValues = SearchPhotosCommand(
            query: query,
            orientation: orientation.name,
            size: ContentSize.large.name
        )
        useCase.search(searchValues) { [weak self] response in
            if case .success(let searchResult) = response {
                let photoCellViewModels = searchResult.photos.toPhotoContentCellViewModels()
                self?.totalItemsFound = searchResult.totalResults
                self?.loadedPhotoContentCellViewModels?(photoCellViewModels)
            }
        }
    }
    
    func onQuerySelect(_ query: String) {
        self.query = query
    }
    
    func currentQuery() -> String {
        return query
    }
}
