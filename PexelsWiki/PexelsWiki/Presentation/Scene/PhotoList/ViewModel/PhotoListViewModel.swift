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
    
    private var isLoading: Bool = false
    private var hasNext: Bool = false
    private var query: String = ""
    private var page: Int = 1
    
    private let orientation: ContentOrientation = .landscape
    private let useCase: SearchPhotosUseCase
    private let maxItemsPerPage: Int
    
    init(maxItemsPerPage: Int = 15, query: String?, useCase: SearchPhotosUseCase) {
        self.maxItemsPerPage = maxItemsPerPage
        self.useCase = useCase
        self.query = query ?? ""
    }
    
    // MARK: Function(s)
    
    func fetchSearchResults() {
        let searchValues = SearchPhotosParameter(
            query: query,
            orientation: orientation.name,
            size: ContentSize.large.name,
            page: page,
            perPage: maxItemsPerPage
        )
        useCase.search(searchValues) { [weak self] response in
            if case .success(let searchedPhotosPage) = response {
                let photoCellViewModels = searchedPhotosPage.items.compactMap {
                    PhotoContentCellViewModel(
                        userName: $0.user.name,
                        imageURLString: $0.sources.large,
                        imageID: $0.id,
                        imageWidth: $0.width,
                        imageHeight: $0.height
                    )
                }
                self?.totalItemsFound = searchedPhotosPage.totalResults
                self?.loadedPhotoContentCellViewModels?(photoCellViewModels)
                self?.updatePageValues(page: searchedPhotosPage.page + 1, hasNext: searchedPhotosPage.hasNext)
                self?.isLoading = false
            }
        }
    }
    
    func fetchNextPage() {
        guard hasNext == true else { return }
        fetchSearchResults()
    }
    
    func resetPage() {
        page = 1
        hasNext = false
        fetchSearchResults()
    }
    
    func updateQuery(_ query: String) {
        self.query = query
    }
    
    func currentQuery() -> String {
        return query
    }
    
    // MARK: Private Function(s)
    
    private func updatePageValues(page: Int, hasNext: Bool) {
        self.page = page
        self.hasNext = hasNext
    }
}
