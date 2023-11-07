//
//  TabCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class TabCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController = .init()
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {

        let homeTabBarItem = makeTabBarItem(type: .home)
        let homeNavigationViewController = UINavigationController()
        homeNavigationViewController.tabBarItem = homeTabBarItem
        homeNavigationViewController.navigationBar.prefersLargeTitles = true
        
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationViewController)
        homeCoordinator.start()
        
        let searchTabBarItem = makeTabBarItem(type: .search)
        let searchNavigatorViewModel = SearchNavigatorViewModel()
        let searchNavigatorViewController = SearchNavigatorViewController()
        searchNavigatorViewController.title = TabTypes.search.title
        searchNavigatorViewController.tabBarItem = searchTabBarItem
        searchNavigatorViewController.viewModel = searchNavigatorViewModel
        
        let searchNavigationViewController = UINavigationController(
            rootViewController: searchNavigatorViewController
        )
        searchNavigationViewController.navigationBar.prefersLargeTitles = true
        
        let tabBarViewController = UITabBarController()
        tabBarViewController.viewControllers = [
            homeNavigationViewController, 
            searchNavigationViewController
        ]
        
        let tabCoordinators: [Coordinator] = [homeCoordinator]
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
