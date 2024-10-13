//
//  Response + model mapping.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


// MARK: - VideoListResponse

extension VideoListResponse {
    
    func toPage() -> Page {
        return Page(index: page, hasNext: nextPage != nil)
    }
    
    func toDomain() -> VideoList {
        return VideoList(
            videos: videoResponses.map { $0.toDomain() }
        )
    }
}

// MARK: - PhotoListResponse

extension PhotoListResponse {
    
    func toDomain() -> PhotoList {
        return PhotoList(
            photos: photoResponses.map { $0.toDomain() }
        )
    }
    
    func toPage() -> Page {
        return Page(index: page, hasNext: nextPage != nil)
    }
}

// MARK: - PhotoResponse

extension PhotoResponse {
    
    private func toUser() -> User {
        return User(
            id: photographerIdentifier,
            name: photographer,
            profileURL: photographerProfileURL
        )
    }
    
    func toPhotoSourceURL() -> PhotoSourceURL {
        return PhotoSourceURL(
            original: source.original,
            large: source.large,
            large2x: source.large2x,
            medium: source.medium,
            portrait: source.portrait,
            landscape: source.landscape,
            tiny: source.tiny
        )
    }
}

// MARK: - UserResponse

extension UserResponse {
    func toDomain() -> User {
        return User(id: id, name: name, profileURL: url)
    }
}

// MARK: - VideoFileResponse

extension VideoFileResponse {
    func toDomain() -> VideoFile {
        return VideoFile(
            id: id,
            quality: quality,
            fileType: fileType,
            width: width ?? .zero,
            height: height ?? .zero,
            fps: fps,
            hostURL: link
        )
    }
}

// MARK: - VideoResponse

extension VideoResponse {
    func toDomain() -> Video {
        return Video(
            id: id,
            width: width ?? .zero,
            height: height ?? .zero,
            url: sourceURL,
            thumbnailURL: thumbnailURL,
            duration: duration,
            user: userResponse.toDomain(),
            videoFiles: videoFilesResponse.map { $0.toDomain() }
        )
    }
}

// MARK: - PhotoResponse

extension PhotoResponse {
    func toDomain() -> Photo {
        return Photo(
            id: id,
            width: width,
            height: height,
            url: url,
            photographer: photographer,
            photographerProfileURL: photographerProfileURL,
            photographerIdentifier: photographerIdentifier,
            title: title,
            sources: source.toDomain()
        )
    }
}

// MARK: - PhotoSourceResponse

extension PhotoSourceResponse {
    func toDomain() -> PhotoSourceURL {
        return PhotoSourceURL(
            original: original,
            large: large,
            large2x: large2x,
            medium: medium,
            portrait: portrait,
            landscape: landscape,
            tiny: tiny
        )
    }
}

// MARK: - MediaResponse

extension MediaResponse {
    func toDomain() -> Media {
        switch self {
        case .photo(let photoResponse):
            return .photo(photoResponse.toDomain())
        case .video(let videoResponse):
            return .video(videoResponse.toDomain())
        }
    }
}

// MARK: - CollectionMediaResponse

extension CollectionMediaResponse {
    func toDomain() -> CollectionMedia {
        return CollectionMedia(
            id: id,
            media: mediaResponses.map { $0.toDomain() }
        )
    }
}

extension CollectionListResponse {
    func toDomain() -> MediaCollectionList {
        return MediaCollectionList(
            collections: collections.map { $0.toDomain() }
        )
    }
    
    func toPage() -> Page {
        return Page(index: page, hasNext: nextPage != nil)
    }
}

extension CollectionResponse {
    func toDomain() -> MediaCollection {
        return MediaCollection(
            id: id,
            title: title,
            description: description,
            isPrivate: isPrivate,
            mediaCount: mediaCount,
            photosCount: photosCount,
            videosCount: videosCount
        )
    }
}
