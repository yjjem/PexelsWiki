//
//  UIImage + imageFromData.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

extension UIImageView {
    
    func addImage(from data: Data) {
        let image = UIImage(data: data)
        self.image = image
    }
}
