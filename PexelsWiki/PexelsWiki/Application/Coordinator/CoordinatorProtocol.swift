//
//  CoordinatorProtocol.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

protocol CoordinatorProtocol: AnyObject {
    
    var childCoordinators: [UUID: CoordinatorProtocol] { get set }
    var identifier: UUID { get }
    
    func start()
}

extension CoordinatorProtocol {
    
    func addChild(_ coordinator: CoordinatorProtocol) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    func removeChild(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeValue(forKey: coordinator.identifier)
    }
    
    func removeAllChilds() {
        childCoordinators.removeAll()
    }
}
