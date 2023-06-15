//
//  NetworkError.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

enum NetworkError: Error {
    case targetRequestFailed(reason: URLError)
    case notHTTPResponse
    case badHTTPResponse(code: Int)
    case decodeFailed(reason: Error)
}
