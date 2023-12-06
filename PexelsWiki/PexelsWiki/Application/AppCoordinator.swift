//
//  AppCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    
    var window: UIWindow { get set }
    
    func showTabBarFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
    
    // MARK: Property(s)
    
    var window: UIWindow
    var childCoordinators: [String: Coordinator] = [:]
    
    let identifier: String = "AppCoordinator"
    
    // MARK: Initialzier(s)
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: Function(s)
    
    func start() {
        window.makeKeyAndVisible()
        showTabBarFlow()
    }
    
    func showTabBarFlow() {
        let tabCoordinator = TabBarCoordinator(window: window)
        childCoordinators[tabCoordinator.identifier] = tabCoordinator
        tabCoordinator.start()
    }
}
