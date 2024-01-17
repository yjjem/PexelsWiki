//
//  AppCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.

import UIKit

final class SceneCoordinator: Coordinator {
    
    // MARK: Property(s)
    
    private let window: UIWindow
    private let navigationController: UINavigationController = .init()
    
    // MARK: Initialzier(s)
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: Function(s)
    
    override func start() {
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showTabBarFlow()
    }
    
    // MARK: Private Function(s)
    
    private func showTabBarFlow() {
        let tabCoordinator = TabBarCoordinator(navigationController: navigationController)
        addChild(tabCoordinator)
        tabCoordinator.start()
    }
}
