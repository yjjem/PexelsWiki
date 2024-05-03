//
//  SearchVideosUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class SearchVideosUseCase: SearchVideosUseCaseInterface {
    
    struct SearchParameters {
        let query: String
        let orientation: String
        let size: String
        let page: Int
        let perPage: Int
    }
    
    // MARK: Property(s)
    
    private let repository: VisualContentRepositoryInterface
    
    // MARK: Initializer
    
    init(repository: VisualContentRepositoryInterface) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func search(
        _ parameters: SearchParameters,
        _ completion: @escaping (Result<VideoPage, Error>) -> Void
    ) -> Cancellable? {
        return repository.searchVideos(
            query: parameters.query,
            orientation: parameters.orientation,
            size: parameters.size,
            page: parameters.page,
            perPage: parameters.perPage
        ) { response in
            
            completion(response)
        }
    }
}
