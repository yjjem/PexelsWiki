//
//  PhotoDetailViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


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
    private let useCase: FetchSpecificPhotoUseCase
    private let imageUtilityManager = ImageUtilityManager()
    
    // MARK: Initializer
    
    init(imageID: Int, useCase: FetchSpecificPhotoUseCase) {
        self.imageID = imageID
        self.useCase = useCase
    }
    
    // MARK: Function(s)
    
    func startFetching() {
        useCase.fetchPhoto(id: imageID) { [weak self] response in
            if case .success(let specificPhoto) = response {
                self?.fetchedPhotoItem?(specificPhoto.toPhoto())
            }
        }
    }
}
