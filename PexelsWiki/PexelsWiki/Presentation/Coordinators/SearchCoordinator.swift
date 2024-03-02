//
//  SearchCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit
import AVKit
import Combine

final class SearchCoordinator: Coordinator {
    
    // MARK: Property(s)
    
    private let navigationController: UINavigationController
    private let sceneFactory: SceneFactory
    
    var observing: NSKeyValueObservation?
    
    deinit {
        observing?.invalidate()
    }
    
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
        photoSearchViewController.viewModel?.coordinator = self
        let videoSearchViewController = sceneFactory.makeVideoSearchViewController(query: query)
        videoSearchViewController.viewModel?.coordinator = self
        
        let viewPages = [photoSearchViewController, videoSearchViewController]
        let searchResultsViewController = SearchResultsViewController()
        searchResultsViewController.configureViewPages(viewPages)
        
        navigationController.tabBarController?.tabBar.isHidden = true
        router.push(searchResultsViewController, animated: true) { [weak self] in
            self?.navigationController.tabBarController?.tabBar.isHidden = false
        }
    }
    
    func showPhotoDetailFlow(id: Int) {
        let photoDetail = sceneFactory.makePhotoDetailViewController(id: id)
        router.push(photoDetail, animated: true, nil)
    }
    
    func showVideoDetailFlow(id: Int) {
        let videoDetailViewController = VideoDetailViewController()
        videoDetailViewController.viewModel = sceneFactory.makeVideoDetailViewModel(id: id)
        router.push(videoDetailViewController, animated: true, nil)
    }
}

// MARK: SearchNavigatorViewControllerDelegate

extension SearchCoordinator: SearchNavigatorViewControllerDelegate {
    
    func didSelectSearchQuery(_ searchQuery: String) {
        showSearchResultsFlow(query: searchQuery)
    }
}
