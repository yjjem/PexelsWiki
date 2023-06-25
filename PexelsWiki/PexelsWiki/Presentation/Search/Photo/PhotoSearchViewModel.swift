//
//  PhotoSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class PhotoSearchViewModel {
    
    var query: String = ""
    var orientation: ContentOrientation = .landscape
    var size: ContentSize = .small
    
    var loadedPhotoResources: (([PhotoResource]) -> Void)?
    
    private var page: Int = 1
    private var pageSize: PageSize = .small
    private var hasNext: Bool = false
    private var contentType: ContentOrientation = .landscape
    
    private let useCase: PexelsPhotoSearchUseCaseInterface
    
    init(useCase: PexelsPhotoSearchUseCaseInterface) {
        self.useCase = useCase
    }
    
    func loadSearchResults() {
        useCase.search(
            query: query,
            orientation: orientation,
            size: size,
            page: page,
            perPage: pageSize.itemsPerPage
        ) { response in
            
            response.onComplete { [weak self] photoPage in
                self?.page = photoPage.page
                self?.hasNext = photoPage.hasNext
                self?.loadedPhotoResources?(photoPage.photos)
            }
        }
    }
}
