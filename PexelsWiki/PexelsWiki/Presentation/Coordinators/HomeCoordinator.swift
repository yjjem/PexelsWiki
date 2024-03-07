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
    private lazy var router = Router(navigationController: navigationController)
    
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
        homeViewController.navigationItem.title = "Curated Photos"
        homeViewController.delegate = self
        router.push(homeViewController, animated: true)
    }
    
    func showDetailFlow(id: Int) {
        let photoDetailViewController = sceneFactory.makePhotoDetailViewController(id: id)
        photoDetailViewController.hidesBottomBarWhenPushed = true
        photoDetailViewController.delegate = self
        router.push(photoDetailViewController, animated: true)
    }
    
    func showUserProfileFlow(url: String) {
        guard let url = URL(string: url) else { return }
        let safariViewController = SFSafariViewController(url: url)
        router.present(safariViewController, animated: true)
    }
    
    func showSaveCompleteFlow() {
        let alertController = UIAlertController(
            title: "Succeed",
            message: "Save complete",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default) { _  in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        router.present(alertController, animated: true, nil)
    }
    
    func showSaveFailedFlow(_ errorMessage: String) {
        let alertController = UIAlertController(
            title: "Failed",
            message: "Save failed with: " + errorMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default) { _  in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        router.present(alertController, animated: true, nil)
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
    
    func didRequestDownload(_ photo: Photo) {
        if let imageToSave = UIImage(data: photo.data) {
            UIImageWriteToSavedPhotosAlbum(
                imageToSave,
                self, #selector(image(_:didFinishSavingWithError:contextInfo:)),
                nil
            )
        } else {
            showSaveFailedFlow("No image")
        }
    }
}

extension HomeCoordinator {
    @objc func image(
        _ image: UIImage,
        didFinishSavingWithError error: NSError?,
        contextInfo: UnsafeRawPointer
    ) {
        if let error {
            showSaveFailedFlow(error.localizedDescription)
        } else {
            showSaveCompleteFlow()
        }
    }
}
