//
//  SceneDelegate.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Property(s)
    
    var window: UIWindow?
    
    private var sceneCoordinator: SceneCoordinator?
    private var coreFactory: CoreFactory?
    
    // MARK: UIWindowSceneDelegate
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let coreDependency = CoreFactory(userSecretKey: MainBundle.apiKey)
        self.coreFactory = coreDependency
        
        let presentationDependency = coreDependency.makePresentationFactory()
        let sceneCoordinator = presentationDependency.makeSceneCoordinator(window: window)
        self.sceneCoordinator = sceneCoordinator
        sceneCoordinator.start()
    }
}
