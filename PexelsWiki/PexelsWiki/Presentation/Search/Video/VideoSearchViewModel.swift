//
//  VideoSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

final class VideoSearchViewModel {
    
    // MARK: Binding(s)
    
    var fetchedVideoPreviewItems: (([VideoPreviewItem]) -> Void)?
    
    // MARK: Property(s)
    
    private var query: String = ""
    private var page: Int = 1
    private var pageSize: PageSize = .small
    private var hasNext: Bool = false
    private var isLoading: Bool = false
    private var contentOrientation: ContentOrientation = .portrait
    private var contentSize: ContentSize = .small
    
    private let useCase: VideoSearchUseCaseInterface
    
    init(useCase: VideoSearchUseCaseInterface) {
        self.useCase = useCase
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
        useCase.search(
            query: query,
            orientation: contentOrientation.name,
            size: contentSize.name,
            page: page,
            perPage: pageSize.itemsPerPage
        ) { [weak self] response in
            
            if case .success(let videoPage) = response {
                self?.isLoading = false
                self?.page = videoPage.page
                self?.hasNext = videoPage.hasNext
                let videoPreviewItem = videoPage.videos.map {
                    let durationFormatter = VideoDurationFormatter(duration: $0.duration)
                    let formattedDuration = durationFormatter.formattedString() ?? ""
                    return VideoPreviewItem(
                        thumbnailImage: $0.image,
                        duration: formattedDuration,
                        id: $0.id
                    )
                }
                self?.fetchedVideoPreviewItems?(videoPreviewItem)
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
        pageSize = .small
        hasNext = false
        fetchSearchResults()
    }
}
