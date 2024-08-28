//
//  MediaCollectionViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


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
    
    private let useCase: RetrieveCollectionMediaService
    private let collectionIdentifier: String
    
    init(useCase: RetrieveCollectionMediaService, collectionIdentifier: String) {
        self.useCase = useCase
        self.collectionIdentifier = collectionIdentifier
    }
    
    deinit {
        cancelToken?.cancel()
    }
    
    // MARK: Function(s)
    
    func onViewDidLoad() {
        cancelToken = useCase.fetchCollectionMedia(collectionIdentifier) { [weak self] response in
            guard case .success(let collectionMedia) = response else {
                return
            }
            
            let previewItems = collectionMedia.media.map { media in
                
                let imageURL: String
                let userName: String
                let identifier: Int
                
                switch media {
                case .photo(let photoCollectionMedia):
                    imageURL = photoCollectionMedia.source.medium
                    userName = photoCollectionMedia.photographer
                    identifier = photoCollectionMedia.id
                case .video(let videoCollectionMedia):
                    imageURL = videoCollectionMedia.image
                    userName = videoCollectionMedia.user.name
                    identifier = videoCollectionMedia.user.id
                }

                return MediaPreview(image: imageURL, user: userName, identifier: identifier)
            }
            
            self?.loadedMediaPreviews?(previewItems)
        }
    }
}
