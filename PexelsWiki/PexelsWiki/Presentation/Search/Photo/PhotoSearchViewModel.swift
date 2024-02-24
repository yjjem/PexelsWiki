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
    
    func updateQuery(_ query: String) {
        self.query = query
    }
    
    func currentQuery() -> String {
        return query
    }
    
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
            if let self, case .success(let photoPage) = response {
                let photoCellViewModels = photoPage.photos.map(makePhotoContentCellViewModel)
                self.isLoading = false
                self.page = photoPage.page
                self.hasNext = photoPage.hasNext
                self.loadedPhotoContentCellViewModels?(photoCellViewModels)
            }
        }
    }
    
    func fetchNextPage() {
        if isLoading {
            return
        }
        
        if hasNext {
            page += 1
            fetchSearchResults()
        }
    }
    
    func resetPage() {
        page = 1
        hasNext = false
        fetchSearchResults()
    }
    
    // MARK: Private Function(s)
    
    private func makePhotoContentCellViewModel(
        _ resource: PhotoResource
    ) -> PhotoContentCellViewModel {
        
        return PhotoContentCellViewModel(
            imageURLString: resource.url["large"]!,
            userName: resource.photographer
        )
    }
}
