//
//  SearchCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit
import AVKit
import SafariServices

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
        
        let viewPages = [photoList, videoList]
        let searchResultsViewController = SearchResultsViewController()
        searchResultsViewController.configureViewPages(viewPages)
        searchResultsViewController.hidesBottomBarWhenPushed = true
        router.push(searchResultsViewController, animated: true, nil)
    }
    
    func showPhotoDetailFlow(id: Int) {
        let photoDetail = sceneFactory.makePhotoDetailViewController(id: id)
        photoDetail.hidesBottomBarWhenPushed = true
        photoDetail.delegate = self
        router.push(photoDetail, animated: true, nil)
    }
    
    func showVideoDetailFlow(id: Int) {
        let videoDetail = sceneFactory.makeVideoDetailViewController(id: id)
        videoDetail.hidesBottomBarWhenPushed = true
        videoDetail.delegate = self
        router.push(videoDetail, animated: true, nil)
    }
    
    func showUserProfileFlow(profileURLString: String) {
        guard let userProfileURL = URL(string: profileURLString) else { return }
        let safariViewController = SFSafariViewController(url: userProfileURL)
        router.present(safariViewController, animated: true, nil)
    }
}

// MARK: SearchNavigatorViewControllerDelegate

extension SearchCoordinator: SearchNavigatorViewControllerDelegate {
    
    func didSelectSearchQuery(_ searchQuery: String) {
        showSearchResultsFlow(query: searchQuery)
    }
}

// MARK: DetailViewControllerDelegate

extension SearchCoordinator: DetailViewControllerDelegate {
    
    func didRequestUserProfile(_ profileURL: String) {
        showUserProfileFlow(profileURLString: profileURL)
    }
    
    func didRequestDownloadPhoto(of id: Int) {
        // TODO: add download flow
    }
}
