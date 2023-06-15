//
//  HTTPURLResponse + validation.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

extension HTTPURLResponse {
    
    func codeIs(_ code: Int) -> Bool {
        return self.statusCode == code
    }
    
    func codeIsNot(_ code: Int) -> Bool {
        return self.statusCode != code
    }
}
