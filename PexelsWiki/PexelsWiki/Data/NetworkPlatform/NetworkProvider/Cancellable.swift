//
//  Cancellable.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

protocol Cancellable {
    func cancel()
}

extension URLSessionDataTask: Cancellable { }
