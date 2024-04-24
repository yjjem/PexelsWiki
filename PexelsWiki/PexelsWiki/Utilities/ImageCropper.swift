//
//  ImageCropper.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import UIKit

struct ImageCropper {
    
    // MARK: Type(s)
    
    enum CropStrategy {
        case none
        case centerSquare
        case centerPreserverRatio
    }
    
    // MARK: Property(s)
    
    private let strategy: CropStrategy
    private let sourceImage: UIImage
    private let frameToFit: CGRect
    
    // MARK: Initializer(s)
    
    init(sourceImage: UIImage, strategy: CropStrategy, frameToFit: CGRect) {
        self.sourceImage = sourceImage
        self.strategy = strategy
        self.frameToFit = frameToFit
    }
    
    // MARK: Function(s)
    
    func crop() -> UIImage? {
        let imageFrame = CGRect(origin: CGPoint(), size: sourceImage.size)
        let width = sourceImage.size.width
        let height = sourceImage.size.height
        
        switch strategy {
        case .none:
            return sourceImage
        case .centerSquare:
            let minSidePoints = min(sourceImage.size.width, sourceImage.size.height)
            let newFrame = imageFrame.insetBy(
                dx: minSidePoints.isEqual(to: width) ? .zero : 0.5 * (width - minSidePoints),
                dy: minSidePoints.isEqual(to: height) ? .zero : 0.5 * (height - minSidePoints)
            )
            return performCroppingElseNil(cropRect: newFrame)

        case .centerPreserverRatio:
            let widthRatio = frameToFit.width / width
            let heightRatio = frameToFit.height / height
            let maxRatio = max(widthRatio, heightRatio)
            let ratioDifference = maxRatio - min(widthRatio, heightRatio)
            let newFrame = imageFrame.insetBy(
                dx: maxRatio.isEqual(to: widthRatio) ? 0.5 * (width * ratioDifference) : .zero ,
                dy: maxRatio.isEqual(to: heightRatio) ? 0.5 * (height * ratioDifference) : .zero
            )
            return performCroppingElseNil(cropRect: newFrame)
        }
    }
    
    // MARK: Private Function(s)
    
    private func performCroppingElseNil(cropRect: CGRect) -> UIImage? {
        guard let croppedCGImage = sourceImage.cgImage?.cropping(to: cropRect) else {
            return sourceImage
        }
        
        return UIImage(
            cgImage: croppedCGImage,
            scale: sourceImage.scale,
            orientation: sourceImage.imageOrientation
        )
    }
}
