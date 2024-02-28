//
//  HomeCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

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
        homeViewController.viewModel?.coordinator = self
        homeViewController.title = TabTypes.home.title
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func showDetailFlow(id: Int) {
        let photoDetailViewController = sceneFactory.makePhotoDetailViewController(id: id)
        photoDetailViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(photoDetailViewController, animated: true)
    }
}
