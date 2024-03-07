//
//  PhotoDetailViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import Foundation

final class PhotoDetailViewModel {
    
    // MARK: Binding(s)
    
    var loadedPhoto: ((Photo) -> Void)?
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
    
    // MARK: Initializer
    
    init(imageID: Int, useCase: FetchSinglePhotoUseCase) {
        self.imageID = imageID
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func startFetching() {
        useCase.fetchPhoto(id: imageID) { [weak self] response in
            if case .success(let photoBundle) = response {
                ImageLoadManager.fetchCachedImageDataElseLoad(
                    urlString: photoBundle.variations.original
                ) { response in
                    if case .success(let photoData) = response {
                        let photo = Photo(
                            title: photoBundle.title,
                            userName: photoBundle.user.name,
                            userProfileURL: photoBundle.user.profileURL,
                            resolution: photoBundle.resolution.toString(),
                            data: photoData
                        )
                        self?.photo = photo
                        self?.loadedPhoto?(photo)
                    }
                }
            }
        }
    }
}
