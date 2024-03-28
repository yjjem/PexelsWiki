//
//  ScrollView + Pagination.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import UIKit

extension UIScrollView {
    
    private var heightDifferenceRatio: CGFloat {
        return contentSize.height / bounds.height
    }
    
    private var boundBottomPoint: CGFloat {
        return bounds.maxY
    }
    
    func isOverPaginationPoint(ratio: CGFloat = 0.8) -> Bool {
        guard heightDifferenceRatio > 1.5 else { return true }
        return boundBottomPoint >= contentSize.height * ratio
    }
}
