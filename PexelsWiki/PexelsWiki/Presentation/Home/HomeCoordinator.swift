//
//  HomeCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class HomeCoordinator: Coordinator {
    
    // MARK: Property(s)
    
    var childCoordinators: [String: Coordinator] = [:]
    
    let identifier: String = "HomeCoordinator"
    
    private let navigationController: UINavigationController
    
    // MARK: Initializer(s)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Function(s)
    
    func start() {
        showMainFlow()
    }
    
    func showMainFlow() {
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
