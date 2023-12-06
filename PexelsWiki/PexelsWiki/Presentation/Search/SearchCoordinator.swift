//
//  SearchCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class SearchCoordinator: Coordinator {
    
    // MARK: Property(s)
    
    var childCoordinators: [String: Coordinator] = [:]
    
    let identifier: String = "SearchCoordinator"
    
    private let navigationController: UINavigationController
    
    // MARK: Initializer(s)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Function(s)
    
    func start() {
        showSearchNavigatorFlow()
    }
    
    func showSearchNavigatorFlow() {
        let searchNavigatorViewModel = SearchNavigatorViewModel()
        let searchNavigatorViewController = SearchNavigatorViewController()
        searchNavigatorViewController.title = TabTypes.search.title
        searchNavigatorViewController.viewModel = searchNavigatorViewModel
        
        navigationController.pushViewController(searchNavigatorViewController, animated: true)
    }
}
