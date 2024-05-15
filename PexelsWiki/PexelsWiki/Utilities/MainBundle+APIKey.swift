//
//  MainBundle + APIKey.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

public let MainBundle = Bundle.main

extension Bundle {
    var apiKey: String {
        
        guard let apiKey = object(forInfoDictionaryKey: "PexelsAPIKey") as? String
        else {
            preconditionFailure("Please check api key format")
        }
        
        return apiKey
    }
}
