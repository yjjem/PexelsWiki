//
//  Result + Better Mapping.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

extension Result {
    
    @discardableResult
    func onComplete(_ completion: (Success) -> Void) -> Result {
        return map { success in
            completion(success)
            return success
        }
    }
    
    @discardableResult
    func onError(_ completion: (Failure) -> Void) -> Result {
        return mapError { error in
            completion(error)
            return error
        }
    }
}
