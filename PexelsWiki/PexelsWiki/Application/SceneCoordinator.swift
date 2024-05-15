//
//  AppCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.

import UIKit

final class SceneCoordinator: Coordinator {
    
    // MARK: Property(s)
    
    private let window: UIWindow
    private let sceneFactory: SceneFactory
    private let navigationController: UINavigationController = .init()
    
    // MARK: Initialzier(s)
    
    init(window: UIWindow, sceneFactory: SceneFactory) {
        self.window = window
        self.sceneFactory = sceneFactory
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
        let tabBarCoordinator = sceneFactory.makeTabBarCoordinator(navigation: navigationController)
        addChild(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
