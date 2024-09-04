//
//  MediaCollectionViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.

import Foundation

final class MediaCollectionViewModel {
    
    // MARK: Type(s)
    
    enum MediaType {
        case photo, video
    }
    
    struct MediaPreview: Hashable {
        let image: String
        let user: String
        let identifier: Int
        let type: MediaType
    }
    
    // MARK: Property(s)
    
    var loadedMediaPreviews: (([MediaPreview]) -> Void)?
    var cancelToken: Cancellable?
    
    private let useCase: FetchCollectionMediaUseCase
    
    init(useCase: FetchCollectionMediaUseCase) {
        self.useCase = useCase
    }
    
    deinit {
        cancelToken?.cancel()
    }
    
    // MARK: Function(s)
    
    func onViewDidLoad() {
        cancelToken = useCase.fetchCollectionMedia { [weak self] response in
            guard case .success(let collectionMedia) = response else {
                return
            }
            
            let previewItems = collectionMedia.media.map { $0.toMediaPreview() }
            
            DispatchQueue.main.async {
                self?.loadedMediaPreviews?(previewItems)
            }
        }
    }
    
    func onNeedMoreItems() {
        cancelToken = useCase.fetchNextCollectionMedia { [weak self] response in
            
            guard case .success(let collectionMedia) = response else {
                return
            }
            
            let previewItems = collectionMedia.media.map { $0.toMediaPreview() }
            
            DispatchQueue.main.async {
                self?.loadedMediaPreviews?(previewItems)
            }
            
        }
    }
}
