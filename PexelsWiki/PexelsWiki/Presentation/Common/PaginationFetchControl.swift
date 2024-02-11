//
//  ScrollPagingControl.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class PaginationFetchControl: NSObject, UIScrollViewDelegate {
    
    // MARK: Property(s)
    
    var didTriggerFetchMore: (() -> Void)?
    
    private var scrollView: UIScrollView?
    
    // MARK: Function(s)
    
    func configure(scrollView: UIScrollView) {
        self.scrollView = scrollView
        scrollView.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleBottomPointY = scrollView.bounds.maxY
        let paginationTriggerPointY = scrollView.contentSize.height * 0.8
        let didReachPaginationTriggerPoint = visibleBottomPointY >= paginationTriggerPointY
        
        if didReachPaginationTriggerPoint {
            didTriggerFetchMore?()
        }
    }
}
