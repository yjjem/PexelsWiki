//
//  Data + DecodeResult.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

extension Data {
    
    func decode<Entity: Decodable>(to type: Entity.Type) -> Result<Entity, Error> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decoded = try decoder.decode(type.self, from: self)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
}
