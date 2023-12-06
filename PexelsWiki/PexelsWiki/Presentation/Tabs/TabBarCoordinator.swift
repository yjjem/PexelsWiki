//
//  TabCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class TabBarCoordinator: Coordinator {
    
    // MARK: Property(s)
    
    var childCoordinators: [String: Coordinator] = [:]
    
    let identifier: String = "TabBarCoordinator"
    
    private let window: UIWindow
    
    // MARK: Initializer(s)
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: Function(s)
    
    func start() {

        let homeNavigationViewController = makeTabNavigationViewController(type: .home)
        let searchNavigationViewController = makeTabNavigationViewController(type: .search)
        
        let tabBarViewController = UITabBarController()
        tabBarViewController.viewControllers = [
            homeNavigationViewController, 
            searchNavigationViewController
        ]
        
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationViewController)
        let searchCoordinator = SearchCoordinator(navigationController: searchNavigationViewController)
        
        let tabCoordinators: [Coordinator] = [homeCoordinator, searchCoordinator]
        tabCoordinators.forEach { coordinator in
            childCoordinators[coordinator.identifier] = coordinator
            coordinator.start()
        }
        
        window.rootViewController = tabBarViewController
    }
    
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
