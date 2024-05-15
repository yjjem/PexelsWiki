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
        let sourceFrame = CGRect(origin: .zero, size: sourceImage.size)
        let width = sourceImage.size.width * sourceImage.scale
        let height = sourceImage.size.height * sourceImage.scale
        
        switch strategy {
        case .none:
            return sourceImage
        case .centerSquare:
            let maxSide = max(sourceFrame.width, sourceFrame.height)
            let minSide = min(sourceFrame.width, sourceFrame.height)
            
            let sideDifference: CGFloat = maxSide - minSide
            let centerRectOriginPoint: Int = Int(0.5 * sideDifference)
            let originX = width.isEqual(to: maxSide) ? centerRectOriginPoint: .zero
            let originY = height.isEqual(to: maxSide) ? centerRectOriginPoint : .zero
            
            let newCenteredOrigin = CGPoint(x: originX, y: originY)
            let newSize = CGSize(width: minSide, height: minSide)
            let newFrame = CGRect(origin: newCenteredOrigin, size: newSize)
            return performCroppingElseNil(cropRect: newFrame)
            
        case .centerPreserverRatio:
            let widthRatio = frameToFit.width / width
            let heightRatio = frameToFit.height / height
            let maxRatio = max(widthRatio, heightRatio)
            let ratioDifference = maxRatio - min(widthRatio, heightRatio)
            let newFrame = sourceFrame.insetBy(
                dx: widthRatio.isEqual(to: maxRatio) ? 0.5 * (width * ratioDifference) : .zero,
                dy: heightRatio.isEqual(to: maxRatio) ? 0.5 * (height * ratioDifference) : .zero
            )
            return performCroppingElseNil(cropRect: newFrame)
        }
    }
    
    // MARK: Private Function(s)
    
    private func performCroppingElseNil(cropRect: CGRect) -> UIImage? {
        let sourceFrame = CGRect(origin: .zero, size: sourceImage.size)
        
        guard !cropRect.equalTo(sourceFrame) else {
            return sourceImage
        }
        
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
