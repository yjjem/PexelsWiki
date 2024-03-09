//
//  UIScrollView + Extension.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import UIKit

extension UIScrollView {
    
    enum VerticalScrollDirection {
        case up
        case down
    }
    
    var currentScrollDirection: VerticalScrollDirection {
        let translationY = panGestureRecognizer.translation(in: self).y
        return  (translationY > 0) ? .down : .up
    }
}
