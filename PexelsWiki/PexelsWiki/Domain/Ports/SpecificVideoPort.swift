//
//  SpecificVideoPort.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


protocol SpecificVideoPort {
    @discardableResult
    func fetchVideoForID(
        _ id: Int,
        _ completion: @escaping (Result<SpecificVideo, Error>) -> Void
    ) -> Cancellable?
}
