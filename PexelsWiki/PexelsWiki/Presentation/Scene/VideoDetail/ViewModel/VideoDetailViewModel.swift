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
    private let useCase: FetchSpecificVideoUseCase
    
    // MARK: Initializer
    
    init(videoID: Int, useCase: FetchSpecificVideoUseCase) {
        self.videoID = videoID
        self.useCase = useCase
    }
    
    deinit {
        videoRequest?.cancel()
    }
    
    // MARK: Function(s)
    
    func startFetchingVideoItem() {
        videoRequest = useCase.fetchVideoBy(id: videoID) { [weak self] response in
            
            guard case .success(let videoResource) = response else {
                return
            }
            
            let hdURL: String = videoResource.files
                .sorted { ($0.width * $0.height) > ($1.width * $1.height)}
                .first(where: { $0.quality == "hd"})?.url ?? ""
            
            let video = Video(
                userName: videoResource.user.name,
                userProfileURL: videoResource.user.profileURL,
                resolution: "\(videoResource.width) x \(videoResource.height)",
                url: hdURL
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
