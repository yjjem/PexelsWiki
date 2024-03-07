//
//  VideoDetailViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class VideoDetailViewModel {
    
    // MARK: Binding(s)
    
    var fetchedVideo: ((Video) -> Void)?
    var profileIsAvailable: (() -> Void)?
    
    // MARK: Property(s)
    
    var userProfileURL: String?
    var video: Video?
    
    private let videoID: Int
    private var videoRequest: Cancellable?
    private let useCase: FetchSingleVideoUseCase
    
    // MARK: Initializer
    
    init(videoID: Int, useCase: FetchSingleVideoUseCase) {
        self.videoID = videoID
        self.useCase = useCase
    }
    
    deinit {
        videoRequest?.cancel()
    }
    
    // MARK: Function(s)
    
    func startFetchingVideoItem() {
        videoRequest = useCase.fetchVideoBy(id: videoID) { [weak self] response in
            if case .success(let videoResource) = response {
                let hdFile = videoResource.videoFiles
                    .sorted { $0.resolution.pixelsCount() > $1.resolution.pixelsCount() }
                    .first(where: { $0.quality == "hd" })?.link ?? ""
                    
                let video = Video(
                    userName: videoResource.user.name,
                    userProfileURL: videoResource.user.profileURL,
                    resolution: videoResource.resolution.toString(),
                    url: hdFile
                )
                self?.video = video
                self?.fetchedVideo?(video)
                self?.userProfileURL = videoResource.user.profileURL
                if videoResource.user.profileURL.isEmpty == false {
                    self?.profileIsAvailable?()
                }
            }
            
        }
    }
}
