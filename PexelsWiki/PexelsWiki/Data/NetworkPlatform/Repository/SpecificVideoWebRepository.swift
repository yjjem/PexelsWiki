//
//  SpecificVideoWebRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class SpecificVideoWebRepository: SpecificVideoPort {
    
    // MARK: Property(s)
    
    private let provider: Networkable
    private let apiFactory: APIFactory
    
    init(provider: Networkable, apiFactory: APIFactory) {
        self.provider = provider
        self.apiFactory = apiFactory
    }
    
    // MARK: Function(s)
    
    func fetchVideoForID(
        _ id: Int,
        _ completion: @escaping (Result<SpecificVideo, FetchSpecificVideoUseCaseError>) -> Void
    ) -> Cancellable? {
        let endPoint = apiFactory.makeVideoEndPoint(id: id)
        
        return provider.send(request: endPoint.makeURLRequest()) { receivedResult in
            
            guard case .success(let receivedData) = receivedResult else {
                completion(.failure(FetchSpecificVideoUseCaseError.fetchFailed))
                return
            }
            
            let finalResult = endPoint.decode(data: receivedData)
                .map { $0.toSpecificVideo() }
                .mapError { _ in FetchSpecificVideoUseCaseError.fetchFailed }
            
            completion(finalResult)
        }
    }
}
