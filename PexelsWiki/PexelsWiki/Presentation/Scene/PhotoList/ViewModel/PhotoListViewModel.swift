//
//  PhotoSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class PhotoListViewModel {
    
    // MARK: Binding(s)
    
    var loadedPhotoContentCellViewModels: (([PhotoContentCellViewModel]) -> Void)?
    
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
        guard isLoading == false else { return }
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
                let photoCellViewModels = photoPage.photos.compactMap {
                    PhotoContentCellViewModel(
                        userName: $0.user.name,
                        imageURLString: $0.variations.landscape,
                        imageID: $0.id
                    )
                }
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
