//
//  CuratedPhotosService.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


final class CuratedPhotosService: FetchCuratedPhotosUseCase {
    
    // MARK: Property(s)
    
    private let port: CuratedPhotosPort
    
    // MARK: Initializer
    
    init(port: CuratedPhotosPort) {
        self.port = port
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func fetchCuratedPhotoPage(
        _ parameters: FetchCuratedPhotosParameter,
        _ completion: @escaping (Result<CuratedPhotosPage, Error>) -> Void
    ) -> Cancellable? {
        return port.fetchCuratedPhotos(
            page: parameters.page,
            perPage: parameters.perPage
        ) { response in
            completion(response)
        }
    }
}
