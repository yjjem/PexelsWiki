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
        searchNavigatorViewController.delegate = self
        
        navigationController.pushViewController(searchNavigatorViewController, animated: true)
    }
    
    func showPhotoSearchFlow(searchQuery: String) {
        let provider = DefaultNetworkProvider()
        let repository = PexelsPhotoRepository(provider: provider)
        let useCase = PexelsPhotoSearchUseCase(repository: repository)
        let photoSearchViewModel = PhotoSearchViewModel(useCase: useCase)
        
        let photoSearchViewController = PhotoSearchViewController()
        photoSearchViewController.viewModel = photoSearchViewModel
        photoSearchViewModel.query = searchQuery
        
        navigationController.pushViewController(photoSearchViewController, animated: true)
    }
    
    func showVideoSearchFlow(searchQuery: String) {
        let provider = DefaultNetworkProvider()
        let repository = PexelsVideoRepository(provider: provider)
        let useCase = PexelsVideoSearchUseCase(repository: repository)
        let videoSearchViewModel = VideoSearchViewModel(useCase: useCase)
        
        let videoSearchViewController = VideoSearchViewController()
        videoSearchViewController.viewModel = videoSearchViewModel
        videoSearchViewModel.query = searchQuery
        
        navigationController.pushViewController(videoSearchViewController, animated: true)
    }
}

extension SearchCoordinator: SearchNavigatorViewControllerDelegate {
    
    func didSelectSearchQuery(_ searchQuery: String, contentType: ContentType) {
        switch contentType {
        case .image: showPhotoSearchFlow(searchQuery: searchQuery)
        case .video: showVideoSearchFlow(searchQuery: searchQuery)
        }
    }
}
