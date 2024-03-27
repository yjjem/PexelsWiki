//
//  VideoContentCellViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.

import Foundation

struct VideoCellViewModel: Hashable {
    let id: Int
    let thumbnailImage: String
    let duration: String
    let imageWidth: Int
    let imageHeight: Int
    
    func thumbnailSize() -> CGSize {
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    func downscaledImageSize(by scaleValue: CGFloat) -> CGSize {
        let downscale = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
        return thumbnailSize().applying(downscale)
    }
}
