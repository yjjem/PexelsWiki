//
//  Router.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

protocol RouterProtocol: NSObject, UINavigationControllerDelegate {
    typealias Completion = () -> Void
    func present(_ viewController: UIViewController, animated: Bool, _ completion: Completion?)
    func dismiss(animated: Bool, _ completion: Completion?)
    func push(_ viewController: UIViewController, animated: Bool, _ completion: Completion?)
    func pop(animated: Bool)
}

final class Router: NSObject, RouterProtocol {
    
    // MARK: Property(s)
    
    private lazy var completions: [UIViewController: Completion] = [:]
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        navigationController.delegate = self
    }
    
    // MARK: Function(s)
    
    func present(
        _ viewController: UIViewController,
        animated: Bool,
        _ completion: Completion? = nil
    ) {
        if let completion {
            completions[viewController] = completion
        }
        navigationController.present(viewController, animated: animated)
    }
    
    func push(
        _ viewController: UIViewController,
        animated: Bool,
        _ completion: Completion? = nil
    ) {
        if let completion {
            completions[viewController] = completion
        }
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func dismiss(animated: Bool, _ completion: Completion?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    // MARK: NavigationControllerDelegate
    
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController, 
        animated: Bool
    ) {
        if let viewTransitionCoordinator = viewController.transitionCoordinator,
           let navigationTransitionCoordinator = navigationController.transitionCoordinator {
            
            [viewTransitionCoordinator, navigationTransitionCoordinator]
             .compactMap { $0.viewController(forKey: .from) }
             .forEach { runCompletion(of: $0) }
        }
    }
    
    private func runCompletion(of viewController: UIViewController) {
        if let runCompletion = completions[viewController] {
            runCompletion()
        }
        completions.removeValue(forKey: viewController)
    }
}
