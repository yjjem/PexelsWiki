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
        let defaultNetworkProvider = DefaultNetworkProvider()
        let photoRepository = PexelsPhotoRepository(provider: defaultNetworkProvider)
        let photoUseCase = PexelsPhotoUseCase(repository: photoRepository)
        let homeViewModel = HomeViewModel(useCase: photoUseCase)
        let homeViewController = HomeViewController()
        
        homeViewController.title = TabTypes.home.title
        homeViewController.tabBarItem = homeTabBarItem
        homeViewController.viewModel = homeViewModel
        
        let homeNavigation = UINavigationController(rootViewController: homeViewController)
        homeNavigation.navigationBar.prefersLargeTitles = true
        
        let searchTabBarItem = makeTabBarItem(type: .search)
        let searchNavigatorViewModel = SearchNavigatorViewModel()
        let searchNavigatorViewController = SearchNavigatorViewController()
        
        searchNavigatorViewController.title = TabTypes.search.title
        searchNavigatorViewController.tabBarItem = searchTabBarItem
        searchNavigatorViewController.viewModel = searchNavigatorViewModel
        
        let searchNavigation = UINavigationController(
            rootViewController: searchNavigatorViewController
        )
        searchNavigation.navigationBar.prefersLargeTitles = true
        
        let tabBarViewController = UITabBarController()
        tabBarViewController.viewControllers = [homeNavigation, searchNavigation]
        
        window.rootViewController = tabBarViewController
    }
    
    private func makeTabBarItem(type: TabTypes) -> UITabBarItem {
        let defaultIcon = UIImage(systemName: type.defaultIconName)
        let selectedIcon = UIImage(systemName: type.selectedIconName)
        
        return UITabBarItem(
            title: type.title,
            image: defaultIcon,
            selectedImage: selectedIcon
        )
    }
}
