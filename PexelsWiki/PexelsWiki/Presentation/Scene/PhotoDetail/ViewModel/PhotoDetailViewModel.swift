//
//  PhotoDetailViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import Foundation

final class PhotoDetailViewModel {
    
    // MARK: Binding(s)
    
    var fetchedPhotoItem: ((Photo) -> Void)?
    var profileIsAvailable: (() -> Void)?
    
    // MARK: Property(s)
    
    var photo: Photo? {
        didSet {
            if let photo, photo.userProfileURL.isEmpty == false {
                profileIsAvailable?()
            }
        }
    }
    
    private let imageID: Int
    private let useCase: FetchSinglePhotoUseCase
    private let imageUtilityManager = ImageUtilityManager()
    
    // MARK: Initializer
    
    init(imageID: Int, useCase: FetchSinglePhotoUseCase) {
        self.imageID = imageID
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func startFetching() {
        useCase.fetchPhoto(id: imageID) { [weak self] response in
            if case .success(let specificPhoto) = response {
                let photo = Photo(
                    title: specificPhoto.title,
                    userName: specificPhoto.user.name,
                    userProfileURL: specificPhoto.user.profileURL,
                    resolution: "\(specificPhoto.width) x \(specificPhoto.height)",
                    url: specificPhoto.sources.original
                )
                self?.fetchedPhotoItem?(photo)
            }
        }
    }
}
