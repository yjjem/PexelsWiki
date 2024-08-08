//
//  FeaturedCollectionsMapping.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

extension FeaturedCollectionsResponse {
    func toPage() -> Page {
        let responseHasNextPage: Bool = nextPage != nil
        return Page(index: page, hasNext: responseHasNextPage)
    }
    
    func toDomain() -> FeaturedCollections {
        let collectionsMappedToDomain = collections.map { $0.toDomain() }
        return FeaturedCollections(collections: collectionsMappedToDomain)
    }
}

extension FeaturedCollectionsResourceResponse {
    func toDomain() -> FeaturedCollectionResource {
        return FeaturedCollectionResource(
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
