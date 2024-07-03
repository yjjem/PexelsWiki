//
//  VideosWebRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

final class VideosWebRepository: SearchVideosPort {
    
    // MARK: Property(s)
    
    private var pages: [Page] = []
    
    private let provider: Networkable
    private let apiFactory: APIFactory
    private let itemsPerPage: Int
    
    init(provider: Networkable, apiFactory: APIFactory, itemsPerPage: Int = 50) {
        self.provider = provider
        self.apiFactory = apiFactory
        self.itemsPerPage = itemsPerPage
    }
    
    // MARK: Function(s)
    
    func searchVideos(
        query: String,
        orientation: String,
        size: String,
        _ completion: @escaping (Result<SearchedVideosResult, SearchVideosUseCaseError>) -> Void
    ) -> Cancellable? {
        
        let endPoint = apiFactory.makeSearchVideosEndPoint(
            query: query, 
            orientation: orientation,
            size: size,
            page: nextPage(),
            perPage: itemsPerPage
        )
        
        return provider.send(request: endPoint.makeURLRequest()) { receivedResult in
            
            guard case .success(let receivedData) = receivedResult else {
                completion(.failure(SearchVideosUseCaseError.searchFailed))
                return
            }
            
            let finalResult = endPoint.decode(data: receivedData)
                .map {
                    self.pages.append($0.toPage())
                    return $0.toSearchedVideosResult()
                }
                .mapError { _ in SearchVideosUseCaseError.searchFailed }
            
            completion(finalResult)
        }
    }
    
    private func nextPage() -> Int {
        guard let lastPage = pages.last else {
            return .zero
        }
        
        return lastPage.index + 1
    }
}
