//
//  Coordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

protocol Coordinator {
    
    var childCoordinators: [String: Coordinator] { get set }
    var identifier: String { get }
    
    func start()
}
