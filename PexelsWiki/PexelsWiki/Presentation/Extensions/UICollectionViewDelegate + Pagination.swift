//
//  UICollectionViewDelegate + Pagination.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import UIKit

extension UICollectionViewDelegate {
    
    func needFetchMore(
        scrollView: UIScrollView,
        willDisplay indexPath: IndexPath,
        itemsCount: Int,
        edgeCountInset: Int
    ) -> Bool {
        guard scrollView.currentScrollDirection == .up else {
            return false
        }
        let currentItemToDisplay: Int = indexPath.item
        let indicatingAlmostFinishedItem = itemsCount - edgeCountInset
        return currentItemToDisplay == indicatingAlmostFinishedItem
    }
}
