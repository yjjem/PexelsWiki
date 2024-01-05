//
//  TabCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class TabBarCoordinator: Coordinator {
    
    private let window: UIWindow
    
    // MARK: Initializer(s)
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: Function(s)
    
    override func start() {
        let homeNavigationViewController = makeTabNavigationViewController(type: .home)
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationViewController)
        
        let searchNavigationViewController = makeTabNavigationViewController(type: .search)
        let searchCoordinator = SearchCoordinator(navigationController: searchNavigationViewController)
        
        let tabCoordinators: [CoordinatorProtocol] = [homeCoordinator, searchCoordinator]
        let tabBarViewController = UITabBarController()
        tabBarViewController.viewControllers = [
            homeNavigationViewController, 
            searchNavigationViewController
        ]
        tabCoordinators.forEach { coordinator in
            addChild(coordinator)
            coordinator.start()
        }
        
        window.rootViewController = tabBarViewController
    }
    
    // MARK: Private Function(s)
    
    private func makeTabNavigationViewController(type: TabTypes) -> UINavigationController {
        let navigationViewController = UINavigationController()
        navigationViewController.tabBarItem = makeTabBarItem(type: type)
        navigationViewController.navigationBar.prefersLargeTitles = true
        
        return navigationViewController
    }
    
    private func makeTabBarItem(type: TabTypes) -> UITabBarItem {
        let defaultIcon = UIImage(systemName: type.defaultIconName)
        let selectedIcon = UIImage(systemName: type.selectedIconName)
        
        return UITabBarItem(title: type.title, image: defaultIcon, selectedImage: selectedIcon)
    }
}
