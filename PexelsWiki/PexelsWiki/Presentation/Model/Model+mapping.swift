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

// MARK: SearchedVideo

extension Array where Element == SearchedVideo {
    
    func toVideoCellViewModels() -> [VideoCellViewModel] {
        return map {
            let durationFormatter = VideoDurationFormatter(duration: $0.duration)
            return VideoCellViewModel(
                id: $0.id,
                thumbnailImage: $0.thumbnail,
                duration: durationFormatter.formattedString() ?? "",
                imageWidth: $0.width,
                imageHeight: $0.height
            )
        }
    }
}

// MARK: SpecificPhoto

extension SpecificPhoto {
    
    func toPhoto() -> Photo {
        return Photo(
            title: title,
            userName: user.name,
            userProfileURL: user.profileURL,
            resolution: "\(width) x \(height)",
            url: sources.original
        )
    }
}

// MARK: SpecificVideo

extension SpecificVideo {
    
    func toVideo() -> Video {
        let hdFile = files
            .sorted { ($0.width * $0.height) > ($1.width * $1.height) }
            .first { $0.quality == "hd" }
        return Video(
            userName: user.name, 
            userProfileURL: user.profileURL,
            resolution: "\(width) x \(height)",
            url: hdFile?.url ?? ""
        )
    }
}
