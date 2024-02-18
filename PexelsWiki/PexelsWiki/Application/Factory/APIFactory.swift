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
        static let image = "v1"
        static let video = "videos"
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
    ) -> EndPoint<WrappedPhotoListResponse> {
        return EndPoint<WrappedPhotoListResponse>(
            baseURL: baseURL,
            path: Path.image,
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
    ) -> EndPoint<WrappedPhotoListResponse> {
        return EndPoint<WrappedPhotoListResponse>(
            baseURL: baseURL,
            path: Path.image,
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
    ) -> EndPoint<WrappedVideoListResponse> {
        return EndPoint<WrappedVideoListResponse>(
            baseURL: baseURL,
            path: Path.video,
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
    ) -> EndPoint<WrappedVideoListResponse> {
        return EndPoint<WrappedVideoListResponse>(
            baseURL: baseURL,
            path: Path.video,
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
