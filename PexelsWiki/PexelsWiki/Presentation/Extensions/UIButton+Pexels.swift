//
//  UIButton + Pexels.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import UIKit

extension UIButton {
    
    func asPexelsButton() {
        backgroundColor = UIColor.pexelsGreen
        tintColor = UIColor.white
        layer.cornerRadius = 11
        layer.cornerCurve = .circular
        layer.masksToBounds = true
    }
}
