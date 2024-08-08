//
//  FeaturedCollectionsWebRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

final class FeaturedCollectionsWebRepository: FetchFeaturedCollectionsPort {
    
    // MARK: Property(s)
    
    private let provider: Networkable
    private let apiFactory: APIFactory
    private let maxItemsPerPage: Int
    private var pages: [Page] = []
    
    init(provider: Networkable, apiFactory: APIFactory, maxItemsPerPage: Int = 30) {
        self.provider = provider
        self.apiFactory = apiFactory
        self.maxItemsPerPage = maxItemsPerPage
    }
    
    // MARK: Function(s)
    
    func fetchFeaturedCollections(
        _ completion: @escaping (Result<FeaturedCollections, DiscoverFeaturedCollectionUseCaseError>) -> Void
    ) -> Cancellable? {
        
        let endPoint = apiFactory.makeFeaturedCollectionsEndPoint(
            page: pages.count,
            perPage: maxItemsPerPage
        )
        
        return provider.send(request: endPoint.makeURLRequest()) { response in
            let mappedResponse = response
                .flatMap { endPoint.decode(data: $0) }
                .map {
                    let page = $0.toPage()
                    self.pages.append(page)
                    return $0.toDomain()
                }
                .mapError { _ in DiscoverFeaturedCollectionUseCaseError.unknown }
            completion(mappedResponse)
        }
    }
    
    func resetPages() {
        pages.removeAll()
    }
}
