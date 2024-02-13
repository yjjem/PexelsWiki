//
//  PhotoSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class PhotoSearchViewModel {
    
    // MARK: Binding(s)
    
    var loadedPhotoContentCellViewModels: (([PhotoContentCellViewModel]) -> Void)?
    var didSelectFilterOptions: ((FilterOptions) -> Void)?
    
    // MARK: Variable(s)
    
    private var filterOptions: FilterOptions = FilterOptions()
    private var pageSize: PageSize = .small
    private var isLoading: Bool = false
    private var hasNext: Bool = false
    private var query: String = ""
    private var page: Int = 1
    
    private let useCase: PhotoSearchUseCaseInterface
    
    init(useCase: PhotoSearchUseCaseInterface) {
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func currentFilterOptions() -> FilterOptions {
        return filterOptions
    }
    
    func updateQuery(_ query: String) {
        self.query = query
    }
    
    func currentQuery() -> String {
        return query
    }
    
    func fetchSearchResults() {
        isLoading = true
        
        useCase.search(
            query: query,
            orientation: filterOptions.orientation.name,
            size: filterOptions.size.name,
            page: page,
            perPage: pageSize.itemsPerPage
        ) { [weak self] response in
            
            if let self, case .success(let photoPage) = response {
                let photoCellViewModels = photoPage.photos.map(makePhotoContentCellViewModel)
                self.isLoading = false
                self.page = photoPage.page
                self.hasNext = photoPage.hasNext
                self.loadedPhotoContentCellViewModels?(photoCellViewModels)
            }
        }
    }
    
    func apply(_ selectedFilterOptions: FilterOptions) {
        self.filterOptions = selectedFilterOptions
        didSelectFilterOptions?(selectedFilterOptions)
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
        pageSize = .small
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
