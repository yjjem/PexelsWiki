//
//  SearchCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class SearchCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private lazy var router: RouterProtocol = Router(navigationController: navigationController)
    
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
        router.push(searchNavigatorViewController, animated: true, nil)
    }
    
    private func showSearchResultsFlow(query: String) {
        let searchResultsViewController = SearchResultsViewController()
        let provider = DefaultNetworkProvider()
        let repository = VisualContentRepository(provider: provider)
        let useCase = PhotoSearchUseCase(repository: repository)
        let photoSearchViewModel = PhotoSearchViewModel(useCase: useCase)
        
        let photoSearchViewController = PhotoSearchViewController()
        photoSearchViewController.viewModel = photoSearchViewModel
        photoSearchViewModel.updateQuery(query)
        
        let videoProvider = DefaultNetworkProvider()
        let videoRepository = VisualContentRepository(provider: videoProvider)
        let videoUseCase = VideoSearchUseCase(repository: videoRepository)
        let videoSearchViewModel = VideoSearchViewModel(useCase: videoUseCase)
        
        let videoSearchViewController = VideoSearchViewController()
        videoSearchViewController.viewModel = videoSearchViewModel
        videoSearchViewModel.updateQuery(query)
            
        searchResultsViewController.configureViewPages([photoSearchViewController, videoSearchViewController])
        
        navigationController.tabBarController?.tabBar.isHidden = true
        router.push(searchResultsViewController, animated: true) { [weak self] in
            self?.navigationController.tabBarController?.tabBar.isHidden = false
        }
    }
}

extension SearchCoordinator: SearchNavigatorViewControllerDelegate {
    
    func didSelectSearchQuery(_ searchQuery: String, contentType: ContentType) {
        showSearchResultsFlow(query: searchQuery)
    }
}
