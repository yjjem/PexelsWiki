//
//  PhotoSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class PhotoSearchViewModel {
    
    // MARK: Variable(s)
    
    var query: String = ""
    var orientation: ContentOrientation = .landscape
    var size: ContentSize = .small
    
    var loadedPhotoContentCellViewModels: (([PhotoContentCellViewModel]) -> Void)?
    
    private var page: Int = 1
    private var pageSize: PageSize = .small
    private var hasNext: Bool = false
    private var isLoading: Bool = false
    private var contentType: ContentOrientation = .landscape
    
    private let useCase: PexelsPhotoSearchUseCaseInterface
    
    init(useCase: PexelsPhotoSearchUseCaseInterface) {
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func loadSearchResults() {
        isLoading = true
        
        useCase.search(
            query: query,
            orientation: orientation.name,
            size: size.name,
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
    
    func apply(filter options: FilterOptions) {
        orientation = options.orientation
        size = options.size
    }
    
    func loadNextPage() {
        if isLoading {
            return
        }
        
        if hasNext {
            page += 1
            loadSearchResults()
        }
    }
    
    func resetPage() {
        page = 1
        pageSize = .small
        hasNext = false
        loadSearchResults()
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
