//
//  CuratedPhotosRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class CuratedPhotosWebRepository: CuratedPhotosPort {
    
    // MARK: Property(s)
    
    private var pages: [Page] = []
    
    private let maxItemsRange: ClosedRange<Int> = 30...80
    private let itemsPerPage: Int
    
    private let provider: Networkable
    private let apiFactory: APIFactory
    
    // MARK: Initializer(s)
    
    init(provider: Networkable, apiFactory: APIFactory, itemsPerPage: Int = 30) {
        self.provider = provider
        self.apiFactory = apiFactory
        self.itemsPerPage = itemsPerPage
    }
    
    // MARK: Function(s)
    
    func fetchCuratedPhotos(
        _ completion: @escaping (Result<[CuratedPhoto], DiscoverCuratedPhotosUseCaseError>) -> Void
    ) -> Cancellable? {
        
        let fetchCuratedPhotosRequest = apiFactory.makeCuratedPhotosEndPoint(
            page: nextPage(),
            perPage: itemsPerPage
        )
        
        return provider.send(request: fetchCuratedPhotosRequest.makeURLRequest()) { fetchResult in
            
            guard case .success(let fetchedData) = fetchResult else {
                completion(.failure(DiscoverCuratedPhotosUseCaseError.failedFetching))
                return
            }
            
            let decodedResponse = fetchCuratedPhotosRequest
                .decode(data: fetchedData)
                .map {
                    let page = $0.toPage()
                    self.pages.append(page)
                    return $0.toCuratedPhotos()
                }
                .mapError { _ in DiscoverCuratedPhotosUseCaseError.invalidPage }
            
            completion(decodedResponse)
        }
    }
    
    func reset() {
        pages.removeAll()
    }
    
    // MARK: Private Function(s)
    
    private func nextPage() -> Int {
        guard let lastPage = pages.last else {
            return .zero
        }
        
        return lastPage.index + 1
    }
}
