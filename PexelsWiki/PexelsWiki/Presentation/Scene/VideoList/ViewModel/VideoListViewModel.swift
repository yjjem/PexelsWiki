//
//  VideoSearchViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class VideoListViewModel {
    
    // MARK: Binding(s)
    
    var fetchedVideoCellViewModelList: (([VideoCellViewModel]) -> Void)?
    
    // MARK: Property(s)
    
    var totalItemsFound: Int = 0
    
    private var query: String = ""
    
    private let contentOrientation: ContentOrientation = .portrait
    private let contentSize: ContentSize = .large
    private let useCase: SearchVideosUseCase
    
    init(query: String?, useCase: SearchVideosUseCase) {
        self.useCase = useCase
        self.query = query ?? ""
    }
    
    // MARK: Function(s)
    
    func onNeedItems() {
        let searchValues = SearchVideosCommand(
            query: query,
            orientation: contentOrientation.name,
            size: contentSize.name
        )
        useCase.search(searchValues) { [weak self] response in
            if case .success(let searchedVideosResult) = response {
                self?.totalItemsFound = searchedVideosResult.totalResults
                self?.fetchedVideoCellViewModelList?(searchedVideosResult.videos.toVideoCellViewModels())
            }
        }
    }
    
    func updateQuery(_ query: String) {
        self.query = query
    }
    
    func currentQuery() -> String {
        return query
    }
}
