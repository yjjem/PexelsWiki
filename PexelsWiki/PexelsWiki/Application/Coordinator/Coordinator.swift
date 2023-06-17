//
//  Coordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

protocol Coordinator {
    
    var childCoordiantors: [Coordinator] { get set }
    
    func start()
}
