//
//  SpecificPhotoWebRepository.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

final class SpecificPhotoWebRepository: SpecificPhotoPort {
    
    // MARK: Property(s)
    
    private let provider: Networkable
    private let apiFactory: APIFactory
    
    init(provider: Networkable, apiFactory: APIFactory) {
        self.provider = provider
        self.apiFactory = apiFactory
    }
    
    // MARK: Function(s)
    
    func fetchPhotoForID(
        _ id: Int, 
        _ completion: @escaping (Result<SpecificPhoto, FetchSpecificPhotoUseCaseError>) -> Void
    ) -> Cancellable? {
        
        let specificPhotoEndPoint = apiFactory.makePhotoEndPoint(id: id)
        
        return provider.send(request: specificPhotoEndPoint.makeURLRequest()) { receivedResult in
            
            guard case .success(let receivedData) = receivedResult else {
                completion(.failure(FetchSpecificPhotoUseCaseError.fetchFailed))
                return
            }

            let finalResult = specificPhotoEndPoint
                .decode(data: receivedData)
                .map { $0.toSpecificPhoto() }
                .mapError { _ in FetchSpecificPhotoUseCaseError.fetchFailed }
            
            completion(finalResult)
        }
    }
}
