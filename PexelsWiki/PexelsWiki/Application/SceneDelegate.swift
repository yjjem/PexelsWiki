//
//  SceneDelegate.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class SceneDelegate: UIResponder {
    
    var window: UIWindow?
}

// MARK: UIWindowSceneDelegate

extension SceneDelegate: UIWindowSceneDelegate {
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
    }
}
