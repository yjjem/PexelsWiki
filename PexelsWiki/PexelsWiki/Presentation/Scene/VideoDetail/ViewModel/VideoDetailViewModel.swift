//
//  VideoDetailViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class VideoDetailViewModel {
    
    // MARK: Binding(s)
    
    var fetchedVideoItem: ((VideoItem) -> Void)?
    var profileIsAvailable: (() -> Void)?
    
    // MARK: Property(s)
    
    var userProfileURL: String? {
        didSet {
            if let userProfileURL, userProfileURL.isEmpty == false {
                profileIsAvailable?()
            }
        }
    }
    let videoID: Int
    
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
                let videoFiles: [VideoFile] = videoResource.videoFiles.map {
                    VideoDetailViewModel.VideoFile(
                        url: $0.link,
                        quality: $0.quality,
                        resolution: $0.resolution.toString(),
                        fileType: $0.fileType
                    )
                }
                let videoItem = VideoItem(
                    userName: videoResource.user.name,
                    resolution: videoResource.resolution.toString(),
                    files: videoFiles
                )
                self?.userProfileURL = videoResource.user.profileURL
                self?.fetchedVideoItem?(videoItem)
            }
        }
    }
}

extension VideoDetailViewModel {
    struct VideoItem {
        let userName: String
        let resolution: String
        let files: [VideoFile]
    }
    
    struct VideoFile {
        let url: String
        let quality: String
        let resolution: String
        let fileType: String
    }
}