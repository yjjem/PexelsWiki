//
//  NetworkError.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

enum ProviderValidationError: Error {
    typealias ResponseCode = Int
    
    case notHTTPResponse
    case badHTTPResponse(_ code: ResponseCode)
}
