//
//  MediaCollection.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.

struct MediaCollection {
    let id: String
    let media: [CollectionMedia]
}

enum CollectionMedia {
    case photo(Photo)
    case video(Video)
}
