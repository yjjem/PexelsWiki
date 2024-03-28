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
        photoList.delegate = self
        let videoList = sceneFactory.makeVideoListViewController(query: query)
        videoList.delegate = self
        
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
    
    func showSaveCompleteFlow() {
        let succeedAlert = sceneFactory.makeSaveSucceedAlert()
        router.present(succeedAlert, animated: true, nil)
    }
    
    func showSaveFailedFlow(_ errorMessage: String) {
        let failedAlert = sceneFactory.makeSaveFailedAlert(errorMessage: errorMessage)
        router.present(failedAlert, animated: true, nil)
    }
}

// MARK: ListSelect Delegates

extension SearchCoordinator: PhotolistViewControllerDelegate, VideoListViewControllerDelegate {
    
    func didSelectPhotoItem(id: Int) {
        showPhotoDetailFlow(id: id)
    }
    
    func didSelectVideoItem(id: Int) {
        showVideoDetailFlow(id: id)
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
    
    func didRequestSave(image: UIImage) {
        let imageSaveCallBackSelector = #selector(image(_:didFinishSavingWithError:contextInfo:))
        UIImageWriteToSavedPhotosAlbum(image, self, imageSaveCallBackSelector, nil)
    }
}

extension SearchCoordinator {
    @objc func image(
        _ image: UIImage,
        didFinishSavingWithError error: NSError?,
        contextInfo: UnsafeRawPointer
    ) {
        if let error {
            showSaveFailedFlow(error.localizedDescription)
        } else {
            showSaveCompleteFlow()
        }
    }
}
