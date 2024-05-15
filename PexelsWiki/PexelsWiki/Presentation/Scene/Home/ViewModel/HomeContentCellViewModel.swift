//
//  HomeContentCellViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

struct HomeContentCellViewModel: Hashable {
    let userName: String
    let userProfileURL: String
    let imageTitle: String
    let imageID: Int
    let imageURL: String
    let imageWidth: Int
    let imageHeight: Int
    let resolutionString: String
    
    func imageSize() -> CGSize {
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    func downScaledImageSize(by downscaleValue: CGFloat) -> CGSize{
        let downScale = CGAffineTransform(scaleX: downscaleValue, y: downscaleValue)
        return imageSize().applying(downScale)
    }
}
