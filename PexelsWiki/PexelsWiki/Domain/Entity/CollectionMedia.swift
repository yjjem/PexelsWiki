//
//  CollectionMedia.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


// MARK: CollectionMedia

struct CollectionMedia: Decodable {
    let id: String
    let media: [Media]
}

// MARK: Media

enum Media: Decodable {
    case photo(PhotoCollectionMedia)
    case video(VideoCollectionMedia)
    
    enum CodingKeys: CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeToDecode = try container.decode(String.self, forKey: .type)
        
        switch typeToDecode {
        case "Photo":
            let decodedPhotoMedia = try PhotoCollectionMedia(from: decoder)
            self = .photo(decodedPhotoMedia)
        case "Video":
            let decodedVideoMedia = try VideoCollectionMedia(from: decoder)
            self = .video(decodedVideoMedia)
        default:
            let typeMisMatchErrorContext = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "type mismatch"
            )
            throw DecodingError.typeMismatch(Self.self, typeMisMatchErrorContext)
        }
    }
}

// MARK: PhotoCollectionMedia

struct PhotoCollectionMedia: Decodable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let photographerProfileURL: String
    let photographerIdentifier: Int
    let source: PhotoSourceURL
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case url
        case photographer
        case photographerProfileURL = "photographerUrl"
        case photographerIdentifier = "photographerId"
        case source = "src"
    }
}

// MARK: VideoCollectionMedia

struct VideoCollectionMedia: Decodable {
    let id: Int
    let width: Int?
    let height: Int?
    let duration: Int
    let url: String
    let image: String
    let user: User
    let videoFiles: [VideoFileResponse]
}
