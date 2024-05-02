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
    private let useCase: PhotoSearchUseCase
    private let maxItemsPerPage: Int
    
    init(maxItemsPerPage: Int = 15, query: String?, useCase: PhotoSearchUseCase) {
        self.maxItemsPerPage = maxItemsPerPage
        self.useCase = useCase
        self.query = query ?? ""
    }
    
    // MARK: Function(s)
    
    func fetchSearchResults() {
        let searchValues = PhotoSearchUseCase.SearchParameters(
            query: query,
            orientation: orientation.name,
            size: ContentSize.large.name,
            page: page,
            perPage: maxItemsPerPage
        )
        useCase.search(searchValues) { [weak self] response in
            if case .success(let photoPage) = response {
                let photoCellViewModels = photoPage.photos.compactMap {
                    PhotoContentCellViewModel(
                        userName: $0.user.name,
                        imageURLString: $0.variations.large,
                        imageID: $0.id,
                        imageWidth: $0.resolution.width,
                        imageHeight: $0.resolution.height
                    )
                }
                self?.totalItemsFound = photoPage.totalResults
                self?.loadedPhotoContentCellViewModels?(photoCellViewModels)
                self?.updatePageValues(page: photoPage.nextPage(), hasNext: photoPage.hasNext)
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
