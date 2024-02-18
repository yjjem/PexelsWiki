//
//  SearchCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class SearchCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let sceneFactory: SceneFactory
    
    private lazy var router: RouterProtocol = Router(navigationController: navigationController)
    
    // MARK: Initializer(s)
    
    init(navigationController: UINavigationController, sceneFactory: SceneFactory) {
        self.navigationController = navigationController
        self.sceneFactory = sceneFactory
    }
    
    // MARK: Function(s)
    
    override func start() {
        showSearchNavigatorFlow()
    }
    
    // MARK: Private Function(s)
    
    func showSearchNavigatorFlow() {
        let searchNavigatorViewController = SearchNavigatorViewController()
        searchNavigatorViewController.viewModel = sceneFactory.makeSearchNavigatorViewModel()
        searchNavigatorViewController.title = TabTypes.search.title
        searchNavigatorViewController.delegate = self
        router.push(searchNavigatorViewController, animated: true, nil)
    }
    
    func showSearchResultsFlow(query: String) {
        let photoSearchViewController = sceneFactory.makePhotoSearchViewController(query: query)
        let videoSearchViewController = sceneFactory.makeVideoSearchViewController(query: query)
        
        let viewPages = [photoSearchViewController, videoSearchViewController]
        let searchResultsViewController = SearchResultsViewController()
        searchResultsViewController.configureViewPages(viewPages)
        
        navigationController.tabBarController?.tabBar.isHidden = true
        router.push(searchResultsViewController, animated: true) { [weak self] in
            self?.navigationController.tabBarController?.tabBar.isHidden = false
        }
    }
}

// MARK: SearchNavigatorViewControllerDelegate

extension SearchCoordinator: SearchNavigatorViewControllerDelegate {
    
    func didSelectSearchQuery(_ searchQuery: String) {
        showSearchResultsFlow(query: searchQuery)
    }
}
