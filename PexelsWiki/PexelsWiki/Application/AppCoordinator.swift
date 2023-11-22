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
    
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.makeKeyAndVisible()
        showTabBarFlow()
    }
    
    func showTabBarFlow() {
        let tabCoordinator = TabBarCoordinator(window: window)
        tabCoordinator.start()
    }
}
