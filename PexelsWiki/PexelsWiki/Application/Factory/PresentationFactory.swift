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
        return HomeViewModel(useCase: domainFactory.makeCuratedPhotosUseCase())
    }
    
    func makeSearchNavigatorViewModel() -> SearchNavigatorViewModel {
        return SearchNavigatorViewModel()
    }
    
    func makePhotoSearchViewModel(query: String? = nil) -> PhotoListViewModel {
        return PhotoListViewModel(
            query: query,
            useCase: domainFactory.makePhotoSearchUseCase()
        )
    }
    
    func makeVideoSearchViewModel(query: String? = nil) -> VideoListViewModel {
        return VideoListViewModel(
            query: query,
            useCase: domainFactory.makeVideoSearchUseCase()
        )
    }
    
    func makePhotoDetailViewModel(id: Int) -> PhotoDetailViewModel {
        return PhotoDetailViewModel(
            imageID: id,
            useCase: domainFactory.makeFetchSinglePhotoUseCase())
    }
    
    func makeVideoDetailViewModel(id: Int) -> VideoDetailViewModel {
        return VideoDetailViewModel(
            videoID: id,
            useCase: domainFactory.makeFetchSingleVideoUseCase()
        )
    }
    
    // MARK: ViewController(s)
    
    func makeHomeViewController() -> HomeViewController {
        let homeViewController = HomeViewController()
        homeViewController.viewModel = makeHomeViewModel()
        return homeViewController
    }
    
    func makePhotoListViewController(query: String? = nil) -> PhotoListViewController {
        let photoSearchViewController = PhotoListViewController()
        photoSearchViewController.viewModel = makePhotoSearchViewModel(query: query)
        return photoSearchViewController
    }
    
    func makeVideoListViewController(query: String? = nil) -> VideoListViewController {
        let videoSearchViewController = VideoListViewController()
        videoSearchViewController.viewModel = makeVideoSearchViewModel(query: query)
        return videoSearchViewController
    }
    
    func makeSearchNavigatorViewController() -> SearchNavigatorViewController {
        let searchNavigator = SearchNavigatorViewController()
        searchNavigator.viewModel = makeSearchNavigatorViewModel()
        return searchNavigator
        
    }
    
    func makePhotoDetailViewController(id: Int) -> PhotoDetailViewController {
        let photoDetail = PhotoDetailViewController()
        photoDetail.viewModel = makePhotoDetailViewModel(id: id)
        return photoDetail
    }
    
    func makeVideoDetailViewController(id: Int) -> VideoDetailViewController {
        let videoDetail = VideoDetailViewController()
        videoDetail.viewModel = makeVideoDetailViewModel(id: id)
        return videoDetail
    }
    
    func makeSaveFailedAlert(errorMessage: String) -> UIAlertController {
        let alertController = UIAlertController(
            title: "Failed",
            message: "Save failed with: " + errorMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default) { _  in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        return alertController
    }
    
    func makeSaveSucceedAlert() -> UIAlertController {
        let alertController = UIAlertController(
            title: "Succeed",
            message: "Save complete",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default) { _  in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        return alertController
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
