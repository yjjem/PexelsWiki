//
//  VisualContentRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class VisualContentRepository: VisualContentRepositoryInterface {
    
    // MARK: Property(s)
    
    private let provider: Networkable
    private let apiFactory: APIFactory
    
    // MARK: Initializer(s)
    
    init(provider: Networkable, apiFactory: APIFactory) {
        self.provider = provider
        self.apiFactory = apiFactory
    }
    
    // MARK: Function(s)

    @discardableResult
    func fetchVideoForID(
        _ id: Int,
        _ completion: @escaping (Result<SpecificVideo, Error>) -> Void
    ) -> Cancellable? {
        let endPoint = apiFactory.makeVideoEndPoint(id: id)
        return provider.send(request: endPoint.makeURLRequest()) { result in
            let mappedResult = result
                .flatMap { endPoint.decode(data: $0) }
                .map { $0.toSpecificVideo() }
            completion(mappedResult)
        }
    }
}
