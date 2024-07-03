//
//  PhotosWebRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class PhotosWebRepository: SearchPhotosPort {
    
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
    
    func searchPhotos(
        _ parameters: SearchPhotosParameter,
        _ completion: @escaping (Result<SearchPhotosResult, SearchPhotosUseCaseError>) -> Void
    ) -> Cancellable? {
        
        let endPoint = apiFactory.makeSearchPhotosEndPoint(
            query: parameters.query,
            orientation: parameters.orientation,
            size: parameters.size,
            page: nextPage(),
            perPage: itemsPerPage
        )
        
        return provider.send(request: endPoint.makeURLRequest()) { receivedResponse in
            
            guard case .success(let receivedData) = receivedResponse else {
                completion(.failure(SearchPhotosUseCaseError.searchFailed))
                return
            }
            
            let finalResult = endPoint
                .decode(data: receivedData)
                .map {
                    self.pages.append($0.toPage())
                    return $0.toSearchPhotosResult()
                }
                .mapError { _ in SearchPhotosUseCaseError.searchFailed }
            
            completion(finalResult)
        }
    }
    
    // MARK: Private Function(s)
    
    private func nextPage() -> Int {
        guard let lastPage = pages.last else {
            return .zero
        }
        
        return lastPage.index + 1
    }
}
