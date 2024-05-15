//
//  Pageable.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol Pageable {
    associatedtype Item
    var page: Int { get }
    var hasNext: Bool { get }
    var totalResults: Int { get }
    var items: [Item] { get }
}
