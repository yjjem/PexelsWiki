//
//  FetchCuratedPhotosUseCase.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class FetchCuratedPhotosUseCase: FetchCuratedPhotosUseCaseInterface {
    
    struct SearchParameters {
        let page: Int
        let perPage: Int
    }
    
    // MARK: Property(s)
    
    private let repository: VisualContentRepositoryInterface
    
    init(repository: VisualContentRepositoryInterface) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func fetchCuratedPhotoPage(
        _ parameters: SearchParameters,
        _ completion: @escaping (Result<PhotoPage, Error>) -> Void
    ) -> Cancellable? {
        return repository.fetchCuratedPhotos(
            page: parameters.page,
            perPage: parameters.perPage
        ) { response in
            completion(response)
        }
    }
}
