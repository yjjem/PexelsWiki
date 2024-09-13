//
//  MediaResponse.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.

enum MediaResponse: Decodable {
    case photo(PhotoResponse)
    case video(VideoResponse)
    
    enum CodingKeys: CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeToDecode = try container.decode(String.self, forKey: .type)
        
        switch typeToDecode {
        case "Photo":
            let decodedPhotoMedia = try PhotoResponse(from: decoder)
            self = .photo(decodedPhotoMedia)
        case "Video":
            let decodedVideoMedia = try VideoResponse(from: decoder)
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
