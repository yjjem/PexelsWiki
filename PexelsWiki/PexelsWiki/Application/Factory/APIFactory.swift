//
//  APIFactory.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.

import Foundation

struct APIFactory {
    
    // MARK: Constant(s)
    
    private enum QueryKey {
        static let query = "query"
        static let orientation = "orientation"
        static let size = "size"
        static let page = "page"
        static let perPage = "perPage"
        static let minWidth = "minWidth"
        static let minHeight = "minHeight"
        static let minDuration = "minDuration"
        static let maxDuration = "maxDuration"
    }
    
    private enum HeaderKey {
        static let authorization = "Authorization"
    }
    
    private enum Path {
        private static let image = "/v1"
        private static let video = "/videos"
        static let searchImages = image + "/search"
        static let curatedImages = image + "/curated"
        static let searchVideos = video + "/search"
        static let popularVideos = video + "/popular"
    }
    
    // MARK: Property(s)
    
    private let baseURL: URL = URL(string: "https://api.pexels.com")!
    private let secretKey: String
    
    // MARK: Initializer(s)
    
    init(secretKey: String) {
        self.secretKey = secretKey
    }
    
    // MARK: Function(s)
    
    func makeCuratedPhotosEndPoint(
        page: Int,
        perPage: Int
    ) -> EndPoint<PhotoListResponse> {
        return EndPoint<PhotoListResponse>(
            baseURL: baseURL,
            path: Path.curatedImages,
            queries: [
                QueryKey.page: String(page),
                QueryKey.perPage: String(perPage)
            ],
            headers: [HeaderKey.authorization: secretKey],
            method: .get
        )
    }
    
    func makeSearchPhotosEndPoint(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int
    ) -> EndPoint<PhotoListResponse> {
        return EndPoint<PhotoListResponse>(
            baseURL: baseURL,
            path: Path.searchImages,
            queries: [
                QueryKey.query: query,
                QueryKey.orientation: orientation,
                QueryKey.page: String(page),
                QueryKey.size: size,
                QueryKey.perPage: String(perPage)
            ],
            headers: [HeaderKey.authorization: secretKey],
            method: .get
        )
    }
    
    func makePopularVideosEndPoint(
        minWidth: Int,
        minHeight: Int,
        minDuration: Int,
        maxDuration: Int,
        page: Int,
        perPage: Int
    ) -> EndPoint<VideoListResponse> {
        return EndPoint<VideoListResponse>(
            baseURL: baseURL,
            path: Path.popularVideos,
            queries: [
                QueryKey.minWidth: String(minWidth),
                QueryKey.minHeight: String(minHeight),
                QueryKey.minDuration: String(minDuration),
                QueryKey.maxDuration: String(maxDuration)
            ],
            headers: [HeaderKey.authorization: secretKey],
            method: .get
        )
    }
    
    func makeSearchVideosEndPoint(
        query: String,
        orientation: String,
        size: String,
        page: Int,
        perPage: Int
    ) -> EndPoint<VideoListResponse> {
        return EndPoint<VideoListResponse>(
            baseURL: baseURL,
            path: Path.searchVideos,
            queries: [
                QueryKey.query: query,
                QueryKey.orientation: orientation,
                QueryKey.size: size,
                QueryKey.page: String(page),
                QueryKey.perPage: String(perPage)
            ],
            headers: [HeaderKey.authorization: secretKey],
            method: .get
        )
    }
}
