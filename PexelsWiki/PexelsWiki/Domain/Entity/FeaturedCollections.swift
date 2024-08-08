//
//  FeaturedCollections.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


struct FeaturedCollections {
    let collections: [FeaturedCollectionResource]
}

struct FeaturedCollectionResource {
    let id: String
    let title: String
    let description: String
    let isPrivate: Bool
    let mediaCount: Int
    let photosCount: Int
    let videosCount: Int
}
