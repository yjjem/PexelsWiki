//
//  Coordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

class Coordinator: CoordinatorProtocol {
    
    var childCoordinators: [UUID : CoordinatorProtocol] = [:]
    let identifier: UUID = .init()
    
    func start() { }
}
