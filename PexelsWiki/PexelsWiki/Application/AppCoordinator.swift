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
        showTabBarFlow()
    }
    
    func showTabBarFlow() {
        
        let homeTabBarItem = UITabBarItem(title: "Home", image: .init(systemName: "house"), tag: 0)
        
        let provider = DefaultNetworkProvider()
        let repository = PexelsPhotoRepository(provider: provider)
        let useCase = PexelsPhotoUseCase(repository: repository)
        let viewModel = HomeViewModel(useCase: useCase)
        
        let homeView = HomeViewController()
        homeView.title = "Curated Photos"
        homeView.viewModel = viewModel
        homeView.tabBarItem = homeTabBarItem
        
        let homeNavigation = UINavigationController(rootViewController: homeView)
        homeNavigation.navigationBar.prefersLargeTitles = true
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [homeNavigation]
        
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
}
