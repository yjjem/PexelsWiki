//
//  PresentationDependency.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    
import UIKit

struct SceneFactory {
    
    // MARK: Property(s)
    
    private let domainFactory: DomainFactory
    
    // MARK: Initializer(s)
    
    init(domainFactory: DomainFactory) {
        self.domainFactory = domainFactory
    }
    
    // MARK: ViewModel(s)
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(maxItemsPerPage: 20, useCase: domainFactory.makeCuratedPhotosUseCase())
    }
    
    func makeSearchNavigatorViewModel() -> SearchNavigatorViewModel {
        return SearchNavigatorViewModel()
    }
    
    func makePhotoSearchViewModel(query: String? = nil) -> PhotoListViewModel {
        return PhotoListViewModel(query: query, useCase: domainFactory.makePhotoSearchUseCase())
    }
    
    func makeVideoSearchViewModel(query: String? = nil) -> VideoListViewModel {
        return VideoListViewModel(query: query, useCase: domainFactory.makeVideoSearchUseCase())
    }
    
    // MARK: ViewController(s)
    
    func makeHomeViewController() -> HomeViewController {
        let homeViewController = HomeViewController()
        homeViewController.viewModel = makeHomeViewModel()
        return homeViewController
    }
    
    func makePhotoSearchViewController(query: String? = nil) -> PhotoListViewController {
        let photoSearchViewController = PhotoListViewController()
        photoSearchViewController.viewModel = makePhotoSearchViewModel(query: query)
        return photoSearchViewController
    }
    
    func makeVideoSearchViewController(query: String? = nil) -> VideoListViewController {
        let videoSearchViewController = VideoListViewController()
        videoSearchViewController.viewModel = makeVideoSearchViewModel(query: query)
        return videoSearchViewController
    }
    
    func makeSearchNavigatorViewController() -> SearchNavigatorViewController {
        let searchNavigator = SearchNavigatorViewController()
        searchNavigator.viewModel = makeSearchNavigatorViewModel()
        return searchNavigator
        
    }
 
    // MARK: Coordinator(s)
    
    func makeTabBarCoordinator(navigation: UINavigationController) -> TabBarCoordinator {
        return TabBarCoordinator(navigationController: navigation, sceneFactory: self)
    }
    
    func makeSearchCoordinator(navigation: UINavigationController) -> SearchCoordinator {
        return SearchCoordinator(navigationController: navigation, sceneFactory: self)
    }
    
    func makeHomeCoordinator(navigation: UINavigationController) -> HomeCoordinator {
        return HomeCoordinator(navigationController: navigation, sceneFactory: self)
    }
    
    func makeSceneCoordinator(window: UIWindow) -> SceneCoordinator {
        return SceneCoordinator(window: window, sceneFactory: self)
    }
}
