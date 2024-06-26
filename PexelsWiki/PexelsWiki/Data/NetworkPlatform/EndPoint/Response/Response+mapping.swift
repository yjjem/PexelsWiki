//
//  Response + model mapping.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

// MARK: VideoListResponse

extension VideoListResponse {
    
    func toSearchedVideosPage() -> SearchedVideosPage {
        return SearchedVideosPage(
            page: page,
            hasNext: nextPage != nil,
            totalResults: totalResults,
            items: videos.map { $0.toSearchedVideo() }
        )
    }
}

extension VideoResourceResponse {
    
    private func toUser() -> User {
        return User(
            id: userResponse.id,
            name: userResponse.name,
            profileURL: userResponse.url
        )
    }
    
    func toSpecificVideo() -> SpecificVideo {
        return SpecificVideo(
            id: id,
            width: width,
            height: height,
            user: toUser(),
            files: toSpecificVideoFiles()
        )
    }
    
    func toSearchedVideo() -> SearchedVideo {
        return SearchedVideo(
            id: id,
            user: toUser(),
            thumbnail: image,
            duration: duration,
            width: width,
            height: height,
            files: toSearchedVideoFiles()
        )
    }
    
    func toSearchedVideoFiles() -> [SearchedVideoFile] {
        return videoFiles.map { file in
            SearchedVideoFile(
                id: file.id,
                width: file.width,
                height: file.height,
                quality: file.quality,
                fileType: file.fileType,
                url: file.link
            )
        }
    }
    
    func toSpecificVideoFiles() -> [SpecificVideoFile] {
        return videoFiles.map { file in
            SpecificVideoFile(
                id: file.id,
                width: file.width,
                height: file.height,
                quality: file.quality,
                fileType: file.fileType,
                url: file.link
            )
        }
    }
}

// MARK: PhotoListResponse

extension PhotoListResponse {
    
    func toCuratedPhotosPage() -> CuratedPhotosPage {
        return CuratedPhotosPage(
            page: page,
            hasNext: nextPage != nil,
            totalResults: totalResults,
            items: photos.compactMap { $0.toCuratedPhoto() }
        )
    }
    
    func toSearchedPhotosPage() -> SearchedPhotosPage {
        return SearchedPhotosPage(
            page: page,
            hasNext: nextPage != nil,
            totalResults: totalResults,
            items: photos.compactMap { $0.toSearchedPhoto() }
        )
    }
}

extension PhotoResourceResponse {
    
    private func toUser() -> User {
        return User(
            id: photographerID,
            name: photographer,
            profileURL: photographerURL
        )
    }
    
    func toPhotoSourceURL() -> PhotoSourceURL {
        return PhotoSourceURL(
            original: imageSources.original,
            large: imageSources.large,
            large2x: imageSources.large2x,
            medium: imageSources.medium,
            portrait: imageSources.portrait,
            landscape: imageSources.landscape,
            tiny: imageSources.tiny
        )
    }
    
    func toSearchedPhoto() -> SearchedPhoto {
        return SearchedPhoto(
            id: id,
            title: title,
            width: width,
            height: height,
            averageColor: averageColor,
            user: toUser(),
            sources: toPhotoSourceURL()
        )
    }
    
    func toCuratedPhoto() -> CuratedPhoto {
        return CuratedPhoto(
            id: id,
            title: title,
            width: width,
            height: height,
            averageColor: averageColor,
            user: toUser(),
            sources: toPhotoSourceURL()
        )
    }
    
    func toPhotoBundle() -> SpecificPhoto {
        return SpecificPhoto(
            id: id,
            title: title,
            width: width,
            height: height,
            averageColor: averageColor,
            user: toUser(),
            sources: toPhotoSourceURL()
        )
    }
}
