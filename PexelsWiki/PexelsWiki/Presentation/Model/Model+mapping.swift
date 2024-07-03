//
//  Model+mapping.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


// MARK: CuratedPhoto

extension Array where Element == CuratedPhoto {
    
    func toHomeContentCellViewModel() -> [HomeContentCellViewModel] {
        return map {
            HomeContentCellViewModel(
                userName: $0.user.name,
                userProfileURL: $0.user.profileURL,
                imageTitle: $0.title,
                imageID: $0.id,
                imageURL: $0.sources.large,
                imageWidth: $0.width,
                imageHeight: $0.height,
                resolutionString: "\($0.width) x \($0.height)"
            )
        }
    }
}

// MARK: SearchedPhoto

extension Array where Element == SearchedPhoto {
    
    func toPhotoContentCellViewModels() -> [PhotoContentCellViewModel] {
        return self.map {
            PhotoContentCellViewModel(
                userName: $0.user.name,
                imageURLString: $0.sources.medium,
                imageID: $0.id,
                imageWidth: $0.width,
                imageHeight: $0.height
            )
        }
    }
}
