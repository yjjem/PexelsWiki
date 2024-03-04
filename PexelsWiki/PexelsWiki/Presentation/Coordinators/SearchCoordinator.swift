//
//  SearchCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit
import AVKit

final class SearchCoordinator: Coordinator {
    
    // MARK: Property(s)
    
    private lazy var router: RouterProtocol = Router(navigationController: navigationController)
    private let navigationController: UINavigationController
    private let sceneFactory: SceneFactory
    
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
        let searchNavigatorViewController = sceneFactory.makeSearchNavigatorViewController()
        searchNavigatorViewController.title = TabTypes.search.title
        searchNavigatorViewController.delegate = self
        router.push(searchNavigatorViewController, animated: true, nil)
    }
    
    func showSearchResultsFlow(query: String) {
        let photoList = sceneFactory.makePhotoListViewController(query: query)
        let videoList = sceneFactory.makeVideoListViewController(query: query)
        photoList.viewModel?.coordinator = self
        videoList.viewModel?.coordinator = self
        
        let viewPages = [photoList, videoList]
        let searchResultsViewController = SearchResultsViewController()
        searchResultsViewController.configureViewPages(viewPages)
        searchResultsViewController.hidesBottomBarWhenPushed = true
        router.push(searchResultsViewController, animated: true, nil)
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
