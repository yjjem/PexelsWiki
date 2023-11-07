//
//  TabCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class TabCoordinator: Coordinator {
    
    // MARK: Property(s)
    
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    // MARK: Initializer(s)
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: Function(s)
    
    func start() {

        let homeTabBarItem = makeTabBarItem(type: .home)
        let homeNavigationViewController = UINavigationController()
        homeNavigationViewController.tabBarItem = homeTabBarItem
        homeNavigationViewController.navigationBar.prefersLargeTitles = true
        
        let searchTabBarItem = makeTabBarItem(type: .search)
        let searchNavigationViewController = UINavigationController()
        searchNavigationViewController.tabBarItem = searchTabBarItem
        searchNavigationViewController.navigationBar.prefersLargeTitles = true
        
        let tabBarViewController = UITabBarController()
        tabBarViewController.viewControllers = [
            homeNavigationViewController, 
            searchNavigationViewController
        ]
        
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationViewController)
        let searchCoordinator = SearchCoordinator(navigationController: searchNavigationViewController)
        
        let tabCoordinators: [Coordinator] = [homeCoordinator, searchCoordinator]
        tabCoordinators.forEach { $0.start() }
        childCoordinators = tabCoordinators
        
        window.rootViewController = tabBarViewController
    }
    
    private func makeTabBarItem(type: TabTypes) -> UITabBarItem {
        let defaultIcon = UIImage(systemName: type.defaultIconName)
        let selectedIcon = UIImage(systemName: type.selectedIconName)
        
        return UITabBarItem(title: type.title, image: defaultIcon, selectedImage: selectedIcon)
    }
}
