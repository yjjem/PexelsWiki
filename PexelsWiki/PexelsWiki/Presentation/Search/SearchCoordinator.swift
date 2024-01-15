//
//  SearchCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class SearchCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    
    // MARK: Initializer(s)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Function(s)
    
    override func start() {
        showSearchNavigatorFlow()
    }
    
    // MARK: Private Function(s)
    
    private func showSearchNavigatorFlow() {
        let searchNavigatorViewModel = SearchNavigatorViewModel()
        let searchNavigatorViewController = SearchNavigatorViewController()
        searchNavigatorViewController.title = TabTypes.search.title
        searchNavigatorViewController.viewModel = searchNavigatorViewModel
        searchNavigatorViewController.delegate = self
        
        navigationController.pushViewController(searchNavigatorViewController, animated: true)
    }
    
    private func showPhotoSearchFlow(searchQuery: String) {
        let provider = DefaultNetworkProvider()
        let repository = VisualContentRepository(provider: provider)
        let useCase = PhotoSearchUseCase(repository: repository)
        let photoSearchViewModel = PhotoSearchViewModel(useCase: useCase)
        
        let photoSearchViewController = PhotoSearchViewController()
        photoSearchViewController.viewModel = photoSearchViewModel
        photoSearchViewModel.query = searchQuery
        
        let photoSearchCoordinator = PhotoSearchCoordinator(rootView: photoSearchViewController)
        photoSearchViewController.delegate = photoSearchCoordinator
        addChild(photoSearchCoordinator)
        
        navigationController.pushViewController(photoSearchViewController, animated: true)
    }
    
    private func showVideoSearchFlow(searchQuery: String) {
        let provider = DefaultNetworkProvider()
        let repository = VisualContentRepository(provider: provider)
        let useCase = VideoSearchUseCase(repository: repository)
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
