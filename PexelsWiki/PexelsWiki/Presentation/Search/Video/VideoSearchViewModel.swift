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
    private var hasNext: Bool = false
    private var isLoading: Bool = false
    
    private let contentOrientation: ContentOrientation = .portrait
    private let contentSize: ContentSize = .small
    private let pageSize: PageSize = .small
    private let useCase: VideoSearchUseCase
    
    init(query: String?, useCase: VideoSearchUseCase) {
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
        let searchValues = VideoSearchUseCase.SearchParameters(
            query: query,
            orientation: contentOrientation.name,
            size: contentSize.name,
            page: page,
            perPage: pageSize.itemsPerPage
        )
        useCase.search(searchValues) { [weak self] response in
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
        hasNext = false
        fetchSearchResults()
    }
}
