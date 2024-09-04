//
//  MediaCollectionViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.

import Foundation

final class MediaCollectionViewModel {
    
    // MARK: Type(s)
    
    struct MediaPreview: Hashable {
        let image: String
        let user: String
        let identifier: String
        
        init(image: String, user: String, identifier: Int) {
            self.image = image
            self.user = user
            self.identifier = String(identifier)
        }
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
}
