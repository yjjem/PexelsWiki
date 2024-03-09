//
//  Response + model mapping.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

// MARK: VideoListResponse

extension VideoListResponse {
    
    func toVideoPage() -> VideoPage {
        return VideoPage(
            page: page,
            hasNext: nextPage != nil,
            totalResults: totalResults,
            videos: videos.map { $0.toVideoBundle() }
        )
    }
}

extension VideoResourceResponse {
    
    func toVideoResolution() -> ContentResolution {
        return ContentResolution(width: width, height: height)
    }
    
    func toVideoFileList() -> [VideoFile] {
        var videoFiles = videoFiles.map {
            VideoFile(
                id: $0.id,
                quality: $0.quality,
                fileType: $0.fileType,
                resolution: toVideoResolution(),
                link: $0.link
            )
        }
        videoFiles.sort(by: { $0.resolution.pixelsCount() > $1.resolution.pixelsCount() })
        return videoFiles
    }
    
    func toVideoBundle() -> VideoBundle {
        return VideoBundle(
            id: id,
            user: userResponse.toUser(),
            duration: duration,
            tags: tags,
            previewURL: image,
            resolution: toVideoResolution(),
            videoFiles: toVideoFileList()
        )
    }
}

extension UserResponse {
    
    func toUser() -> User {
        return User(id: id, name: name, profileURL: url)
    }
}

// MARK: PhotoListResponse

extension PhotoListResponse {
    
    func toPhotoPage() -> PhotoPage {
        return PhotoPage(
            page: page,
            hasNext: nextPage != nil,
            totalResults: totalResults,
            photos: photos.compactMap { $0.toPhotoBundle() }
        )
    }
}

extension PhotoResourceResponse {
    
    func toUser() -> User {
        return User(
            id: photographerID,
            name: photographer,
            profileURL: photographerURL
        )
    }
    
    func toPhotoResolution() -> ContentResolution {
        return ContentResolution(width: width, height: height)
    }
    
    func toPhotoVariations() -> PhotoVariations {
        return PhotoVariations(
            original: imageSources.original,
            large: imageSources.large,
            large2x: imageSources.large2x,
            medium: imageSources.medium,
            portrait: imageSources.portrait,
            landscape: imageSources.landscape,
            tiny: imageSources.tiny
        )
    }
    
    func toPhotoBundle() -> PhotoBundle {
        return PhotoBundle(
            id: id,
            user: toUser(),
            title: title,
            variations: toPhotoVariations(),
            resolution: toPhotoResolution()
        )
    }
}
