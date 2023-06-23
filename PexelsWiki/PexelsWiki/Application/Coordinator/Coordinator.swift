//
//  Coordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

protocol Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}
