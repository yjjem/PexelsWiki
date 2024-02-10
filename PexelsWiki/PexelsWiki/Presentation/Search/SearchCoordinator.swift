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
    
    private func showSearchResultsFlow(query: String) {
        let searchResultsViewController = SearchResultsViewController()
        let provider = DefaultNetworkProvider()
        let repository = VisualContentRepository(provider: provider)
        let useCase = PhotoSearchUseCase(repository: repository)
        let photoSearchViewModel = PhotoSearchViewModel(useCase: useCase)
        
        let photoSearchViewController = PhotoSearchViewController()
        photoSearchViewController.viewModel = photoSearchViewModel
        photoSearchViewModel.query = query
        
        let videoProvider = DefaultNetworkProvider()
        let videoRepository = VisualContentRepository(provider: videoProvider)
        let videoUseCase = VideoSearchUseCase(repository: videoRepository)
        let videoSearchViewModel = VideoSearchViewModel(useCase: videoUseCase)
        
        let videoSearchViewController = VideoSearchViewController()
        videoSearchViewController.viewModel = videoSearchViewModel
        videoSearchViewModel.query = query
            
        searchResultsViewController.configureViewPages([photoSearchViewController, videoSearchViewController])
        navigationController.pushViewController(searchResultsViewController, animated: true)
    }
}

extension SearchCoordinator: SearchNavigatorViewControllerDelegate {
    
    func didSelectSearchQuery(_ searchQuery: String, contentType: ContentType) {
        showSearchResultsFlow(query: searchQuery)
    }
}
