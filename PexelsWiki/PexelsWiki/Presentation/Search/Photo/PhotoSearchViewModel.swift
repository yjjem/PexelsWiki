//
//  PhotoSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class PhotoSearchViewModel {
    
    // MARK: Binding(s)
    
    var loadedPhotoContentCellViewModels: (([PhotoContentCellViewModel]) -> Void)?
    var didSelectFilterOptions: ((FilterOptions) -> Void)?
    
    // MARK: Property(s)
    
    private var isLoading: Bool = false
    private var hasNext: Bool = false
    private var query: String = ""
    private var page: Int = 1
    
    private let orientation: ContentOrientation = .landscape
    private let pageSize: PageSize = .small
    private let useCase: PhotoSearchUseCase
    
    init(query: String?, useCase: PhotoSearchUseCase) {
        self.useCase = useCase
        self.query = query ?? ""
    }
    
    // MARK: Function(s)
    
    func fetchSearchResults() {
        isLoading = true
        let searchValues = PhotoSearchUseCase.SearchParameters(
            query: query,
            orientation: orientation.name,
            size: ContentSize.large.name,
            page: page,
            perPage: pageSize.itemsPerPage
        )
        useCase.search(searchValues) { [weak self] response in
            if case .success(let photoPage) = response {
                self?.updatePageValues(page: photoPage.nextPage(), hasNext: photoPage.hasNext)
                let photoCellViewModels = photoPage.photos.compactMap {
                    PhotoContentCellViewModel(
                        imageURLString: $0.variations.landscape,
                        userName: $0.user.name
                    )
                }
                self?.loadedPhotoContentCellViewModels?(photoCellViewModels)
                self?.isLoading = false
            }
        }
    }
    
    func fetchNextPage() {
        guard isLoading == false else { return }
        guard hasNext == false else { return }
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
