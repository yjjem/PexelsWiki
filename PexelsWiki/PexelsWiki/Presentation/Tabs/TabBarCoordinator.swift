//
//  TabCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class TabBarCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        let defaultAppearance = UITabBarAppearance()
        tabBarController.tabBar.standardAppearance = defaultAppearance
        tabBarController.tabBar.scrollEdgeAppearance = defaultAppearance
        return tabBarController
    }()
    
    // MARK: Initializer(s)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Function(s)
    
    override func start() {
        let homeNavigationViewController = makeTabNavigationViewController(type: .home)
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationViewController)
        
        let searchNavigationViewController = makeTabNavigationViewController(type: .search)
        let searchCoordinator = SearchCoordinator(navigationController: searchNavigationViewController)
        
        let tabCoordinators: [CoordinatorProtocol] = [homeCoordinator, searchCoordinator]
        tabBarController.viewControllers = [
            homeNavigationViewController,
            searchNavigationViewController
        ]
        tabCoordinators.forEach { coordinator in
            addChild(coordinator)
            coordinator.start()
        }
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    // MARK: Private Function(s)
    
    private func makeTabNavigationViewController(type: TabTypes) -> UINavigationController {
        let navigationViewController = UINavigationController()
        navigationViewController.tabBarItem = makeTabBarItem(type: type)
        navigationViewController.navigationBar.prefersLargeTitles = true
        let defaultAppearance = UINavigationBarAppearance()
        navigationViewController.navigationBar.standardAppearance = defaultAppearance
        navigationViewController.navigationBar.scrollEdgeAppearance = defaultAppearance
        
        return navigationViewController
    }
    
    private func makeTabBarItem(type: TabTypes) -> UITabBarItem {
        let defaultIcon = UIImage(systemName: type.defaultIconName)
        let selectedIcon = UIImage(systemName: type.selectedIconName)
        
        return UITabBarItem(title: type.title, image: defaultIcon, selectedImage: selectedIcon)
    }
}
