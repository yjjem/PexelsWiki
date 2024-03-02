//
//  VideoDetailViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class VideoDetailViewModel {
    
    // MARK: Binding(s)
    
    var fetchedVideoItem: ((VideoItem) -> Void)?
    
    // MARK: Property(s)
    
    private let videoID: Int
    private let useCase: FetchSingleVideoUseCase
    private var videoRequest: Cancellable?
    
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
