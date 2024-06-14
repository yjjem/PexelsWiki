//
//  SpecificPhotoService.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


final class SpecificPhotoService: FetchSpecificPhotoUseCase {
    
    // MARK: Property(s)
    
    private let port: FetchSpecificPhotoPort
    
    // MARK: Initializer
    
    init(port: FetchSpecificPhotoPort) {
        self.port = port
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func fetchPhoto(
        id: Int,
        _ completion: @escaping (Result<SpecificPhoto, Error>) -> Void
    ) -> Cancellable? {
        return port.fetchPhotoForID(id, completion)
    }
}
