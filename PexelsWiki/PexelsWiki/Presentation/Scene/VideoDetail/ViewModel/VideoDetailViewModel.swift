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
    var video: Video? {
        didSet {
            if let video {
                fetchedVideo?(video)
            }
        }
    }
    
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
            
            guard case .success(let specificVideo) = response else {
                return
            }
            
            let video = specificVideo.toVideo()
            self?.video = video
            self?.userProfileURL = video.userProfileURL
            
            if !video.userProfileURL.isEmpty {
                self?.profileIsAvailable?()
            }
        }
    }
}
