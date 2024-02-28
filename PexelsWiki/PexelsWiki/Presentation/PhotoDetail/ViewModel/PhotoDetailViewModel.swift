//
//  PhotoDetailViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import Foundation

final class PhotoDetailViewModel {
    
    // MARK: Binding(s)
    
    var loadedPhotoInformation: ((PhotoInformation) -> Void)?
    var loadedPhotoData: ((Data) -> Void)?
    
    // MARK: Property(s)
    
    private var userProfileURL: String?
    
    private let imageID: Int
    private let useCase: FetchSinglePhotoUseCase
    
    // MARK: Initializer
    
    init(imageID: Int, useCase: FetchSinglePhotoUseCase) {
        self.imageID = imageID
        self.useCase = useCase
    }
    
    func startFetching() {
        useCase.fetchPhoto(id: imageID) { [weak self] response in
            if case .success(let photoBundle) = response {
                let photoInformation = PhotoInformation(
                    title: photoBundle.title,
                    userName: photoBundle.user.name,
                    resolution: photoBundle.resolution.toString()
                )
                self?.loadedPhotoInformation?(photoInformation)
                self?.userProfileURL = photoBundle.user.profileURL
                
                let originalPhotoURL = photoBundle.variations.original
                ImageLoadManager.fetchCachedImageDataElseLoad(urlString: originalPhotoURL) {
                    response in
                    
                    if case .success(let photoData) = response {
                        self?.loadedPhotoData?(photoData)
                    }
                }
            }
        }
    }
}

// MARK: PhotoInformation

extension PhotoDetailViewModel {
    struct PhotoInformation {
        let title: String
        let userName: String
        let resolution: String
    }
}
