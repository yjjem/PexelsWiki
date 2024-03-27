//
//  VideoSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

final class VideoListViewModel {
    
    // MARK: Binding(s)
    
    var fetchedVideoCellViewModelList: (([VideoCellViewModel]) -> Void)?
    
    // MARK: Property(s)
    
    var totalItemsFound: Int = 0
    
    private var query: String = ""
    private var page: Int = 1
    private var hasNext: Bool = false
    private var isLoading: Bool = false
    
    private let contentOrientation: ContentOrientation = .portrait
    private let contentSize: ContentSize = .large
    private let useCase: VideoSearchUseCase
    private let maxItemsPerPage: Int
    
    init(maxItemsPerPage: Int = 15, query: String?, useCase: VideoSearchUseCase) {
        self.maxItemsPerPage = maxItemsPerPage
        self.useCase = useCase
        self.query = query ?? ""
    }
    
    // MARK: Function(s)
    
    func fetchSearchResults() {
        guard isLoading == false else { return }
        isLoading = true
        let searchValues = VideoSearchUseCase.SearchParameters(
            query: query,
            orientation: contentOrientation.name,
            size: contentSize.name,
            page: page,
            perPage: maxItemsPerPage
        )
        useCase.search(searchValues) { [weak self] response in
            if case .success(let videoPage) = response {
                let videoPreviewItem = videoPage.videos.map {
                    let durationFormatter = VideoDurationFormatter(duration: $0.duration)
                    let formattedDuration = durationFormatter.formattedString() ?? ""
                    return VideoCellViewModel(
                        id: $0.id,
                        thumbnailImage: $0.previewURL,
                        duration: formattedDuration,
                        imageWidth: $0.resolution.width,
                        imageHeight: $0.resolution.height
                    )
                }
                self?.totalItemsFound = videoPage.totalResults
                self?.updatePageValues(page: videoPage.nextPage(), hasNext: videoPage.hasNext)
                self?.fetchedVideoCellViewModelList?(videoPreviewItem)
                self?.isLoading = false
            }
        }
    }
    
    func updateQuery(_ query: String) {
        self.query = query
    }
    
    func currentQuery() -> String {
        return query
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
    
    // MARK: Private Function(s)
    
    private func updatePageValues(page: Int, hasNext: Bool) {
        self.page = page
        self.hasNext = hasNext
    }
}
