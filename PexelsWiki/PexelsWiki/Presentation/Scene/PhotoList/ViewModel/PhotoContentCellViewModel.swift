//
//  PhotoContentViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

struct PhotoContentCellViewModel: Hashable {
    let userName: String
    let imageURLString: String
    let imageID: Int
    let imageWidth: Int
    let imageHeight: Int
    
    func imageSize() -> CGSize {
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    func downScaledImageSize(by downscaleValue: CGFloat) -> CGSize{
        let downScale = CGAffineTransform(scaleX: downscaleValue, y: downscaleValue)
        return imageSize().applying(downScale)
    }
}
