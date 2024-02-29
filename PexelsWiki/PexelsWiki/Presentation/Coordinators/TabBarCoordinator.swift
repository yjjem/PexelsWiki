//
//  TabCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class TabBarCoordinator: Coordinator {
    
    // MARK: Property(s)
    
    private let sceneFactory: SceneFactory
    private let navigationController: UINavigationController
    private let tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        let defaultAppearance = UITabBarAppearance()
        tabBarController.tabBar.standardAppearance = defaultAppearance
        tabBarController.tabBar.scrollEdgeAppearance = defaultAppearance
        return tabBarController
    }()
    
    // MARK: Initializer(s)
    
    init(navigationController: UINavigationController, sceneFactory: SceneFactory) {
        self.navigationController = navigationController
        self.sceneFactory = sceneFactory
    }
    
    // MARK: Function(s)
    
    override func start() {
        let homeNavigation = makeTabNavigationViewController(type: .home)
        let searchNavigation = makeTabNavigationViewController(type: .search)
        let homeCoordinator = sceneFactory.makeHomeCoordinator(navigation: homeNavigation)
        let searchCoordinator = sceneFactory.makeSearchCoordinator(navigation: searchNavigation)
        
        tabBarController.viewControllers = [homeNavigation, searchNavigation]
        let tabCoordinators: [CoordinatorProtocol] = [homeCoordinator, searchCoordinator]
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
