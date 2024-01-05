//
//  HomeCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class HomeCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    
    // MARK: Initializer(s)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Function(s)
    
    override func start() {
        showMainFlow()
    }
    
    // MARK: Private Function(s)
    
    private func showMainFlow() {
        let defaultNetworkProvider = DefaultNetworkProvider()
        let photoRepository = PexelsPhotoRepository(provider: defaultNetworkProvider)
        let photoUseCase = PexelsPhotoUseCase(repository: photoRepository)
        let homeViewModel = HomeViewModel(useCase: photoUseCase)
        let homeViewController = HomeViewController()
        homeViewController.viewModel = homeViewModel
        homeViewController.title = TabTypes.home.title
        
        navigationController.pushViewController(homeViewController, animated: false)
    }
}
