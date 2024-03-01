//
//  ContentResolution.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

struct ContentResolution {
    let width: Int
    let height: Int
    
    func toString() -> String {
        return String(width) + " X " + String(height)
    }
    
    func pixelsCount() -> Int {
        return width * height
    }
}
