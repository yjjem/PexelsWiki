//
//  PhotoSearchCoordinator.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation
import UIKit

final class PhotoSearchCoordinator: Coordinator {
    
    // MARK: Property(s)
    
    private let rootView: PhotoSearchViewController
    
    // MARK: Initializer(s)
    
    init(rootView: PhotoSearchViewController) {
        self.rootView = rootView
    }
    
    // MARK: Private Function(s)
    
    private func showFilterFlow(_ filterOptions: FilterOptions) {
        let filterViewModel = SearchFilterViewModel(
            selectedOrientation: filterOptions.orientation,
            selectedSize: filterOptions.size
        )
        let filterView = SearchFilterViewController()
        filterView.viewModel = filterViewModel
        filterView.delegate = self
        let filterNavigationView = UINavigationController(rootViewController: filterView)
        rootView.present(filterNavigationView, animated: true)
    }
}

// MARK: PhotoSearchViewControllerDelegate

extension PhotoSearchCoordinator: PhotoSearchViewControllerDelegate {
    func didTapFilterButton(_ currentOptions: FilterOptions) {
        showFilterFlow(currentOptions)
    }
}

// MARK: SearchFilterViewControllerDelegate

extension PhotoSearchCoordinator: SearchFilterViewControllerDelegate {
    func didApplyFilterOptions(_ options: FilterOptions) {
        rootView.viewModel?.apply(options)
        rootView.dismiss(animated: true)
    }
}
