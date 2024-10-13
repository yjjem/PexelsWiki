//
//  User.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


struct User: Decodable {
    let id: Int
    let name: String
    let profileURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileURL = "url"
    }
}
