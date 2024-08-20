//
//  MediaCollectionViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class MediaCollectionViewModel {
    
    // MARK: Property(s)
    
    var loadedMediaCollection: ((CollectionMedia) -> Void)?
    var cancelToken: Cancellable?
    
    private let useCase: RetrieveCollectionMediaService
    private let collectionIdentifier: String
    
    init(
        useCase: RetrieveCollectionMediaService,
        collectionIdentifier: String
    ) {
        self.useCase = useCase
        self.collectionIdentifier = collectionIdentifier
    }
    
    deinit {
        cancelToken?.cancel()
    }
    
    // MARK: Function(s)
    
    func onViewDidLoad() {
        cancelToken = useCase.fetchCollectionMedia(collectionIdentifier) {
            [weak self] response in
            
            // TODO: Handle Error
            
            guard case .success(let collectionMedia) = response else {
                return
            }
            
            self?.loadedMediaCollection?(collectionMedia)
        }
    }
}
