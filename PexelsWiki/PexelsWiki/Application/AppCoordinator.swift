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
    
    var childCoordiantors: [Coordinator] = []
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showTabBarFlow()
    }
    
    func showTabBarFlow() {
        let provider = DefaultNetworkProvider()
        let repository = PexelsPhotoRepository(provider: provider)
        let useCase = PexelsPhotoUseCase(repository: repository)
        let viewModel = HomeViewModel(useCase: useCase)
        let homeView = HomeViewController()
        homeView.viewModel = viewModel
        
        window.rootViewController = homeView
        window.makeKeyAndVisible()
    }
}
