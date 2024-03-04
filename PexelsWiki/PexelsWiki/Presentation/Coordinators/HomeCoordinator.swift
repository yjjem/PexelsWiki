//
//  HomeCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit
import SafariServices

final class HomeCoordinator: Coordinator {
    
    // MARK: Property(s)
    
    private let sceneFactory: SceneFactory
    private let navigationController: UINavigationController
    
    // MARK: Initializer(s)
    
    init(navigationController: UINavigationController, sceneFactory: SceneFactory) {
        self.navigationController = navigationController
        self.sceneFactory = sceneFactory
    }
    
    // MARK: Function(s)
    
    override func start() {
        showMainFlow()
    }
    
    // MARK: Private Function(s)
    
    func showMainFlow() {
        let homeViewController = sceneFactory.makeHomeViewController()
        homeViewController.delegate = self
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func showDetailFlow(id: Int) {
        let photoDetailViewController = sceneFactory.makePhotoDetailViewController(id: id)
        photoDetailViewController.hidesBottomBarWhenPushed = true
        photoDetailViewController.delegate = self
        navigationController.pushViewController(photoDetailViewController, animated: true)
    }
    
    func showUserProfileFlow(url: String) {
        guard let url = URL(string: url) else { return }
        let safariViewController = SFSafariViewController(url: url)
        navigationController.present(safariViewController, animated: true)
    }
}

// MARK: HomeViewControllerDelegate

extension HomeCoordinator: HomeViewControllerDelegate {
    
    func didSelectItem(id: Int) {
        showDetailFlow(id: id)
    }
}

// MARK: DetailViewControllerDelegate

extension HomeCoordinator: DetailViewControllerDelegate {
    
    func didRequestUserProfile(_ userProfileURL: String) {
        showUserProfileFlow(url: userProfileURL)
    }
    
    func didRequestDownloadPhoto(of id: Int) {
        // TODO: add download photo
    }
}
