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
    
    weak var coordinator: SearchCoordinator?
    
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
    
    func fetchSearchResults() {
        guard isLoading == false else { return }
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
                let videoPreviewItem = videoPage.videos.map {
                    let durationFormatter = VideoDurationFormatter(duration: $0.duration)
                    let formattedDuration = durationFormatter.formattedString() ?? ""
                    return VideoCellViewModel(
                        thumbnailImage: $0.previewURL,
                        duration: formattedDuration,
                        id: $0.id
                    )
                }
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
    
    func selectItem(videoID: Int) {
        coordinator?.showVideoDetailFlow(id: videoID)
    }
    
    // MARK: Private Function(s)
    
    private func updatePageValues(page: Int, hasNext: Bool) {
        self.page = page
        self.hasNext = hasNext
    }
}
