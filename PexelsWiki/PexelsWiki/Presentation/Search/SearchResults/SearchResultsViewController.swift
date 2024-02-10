//
//  SearchResultsViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class SearchResultsViewController: UIViewController {
    
    // MARK: Property(s)
    
    private var viewPages: [UIViewController] = [] {
        didSet {
            viewPages.forEach { $0.loadViewIfNeeded() }
        }
    }
    
    private let pageSegmentControl = UISegmentedControl()
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureStyle()
        configureInitialPage()
    }
    
    // MARK: Function(s)
    
    func configureViewPages(_ viewControllers: [UIViewController]) {
        self.viewPages = viewControllers
    }
    
    // MARK: Private Function(s)
    
    private func configureHierarchy() {
        pageSegmentControl.insertSegment(withTitle: "Photos", at: 0, animated: false)
        pageSegmentControl.insertSegment(withTitle: "Videos", at: 0, animated: false)
        pageSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        pageSegmentControl.selectedSegmentIndex = 0
        pageSegmentControl.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
        navigationItem.titleView = pageSegmentControl
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    private func configureInitialPage() {
        guard let initialPage = viewPages.first else { return }
        pageViewController.setViewControllers([initialPage], direction: .forward, animated: false)
    }
    
    private func configureStyle() {
        view.backgroundColor = .systemGray4
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.preferredSearchBarPlacement = .inline
    }
    
    @objc private func didChangeSegment() {
        let selectedPageIndex = pageSegmentControl.selectedSegmentIndex
        let pageToMove: [UIViewController] = [viewPages[selectedPageIndex]]
        let direction: UIPageViewController.NavigationDirection =
        selectedPageIndex == 0 ? .reverse : .forward
        pageViewController.setViewControllers(pageToMove, direction: direction, animated: true)
    }
}

extension SearchResultsViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        
        let currentVc = viewPages.filter { !previousViewControllers.contains($0) }
        if let currentVcFirst = currentVc.first,
           let currentIndex = viewPages.firstIndex(of: currentVcFirst)
        {
            pageSegmentControl.selectedSegmentIndex = currentIndex
            pageSegmentControl.setEnabled(true, forSegmentAt: currentIndex)
        }
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        
        guard let currentIndex = viewPages.firstIndex(of: viewController),
              currentIndex != 0 else { return nil }
        
        return viewPages[currentIndex - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        
        guard let currentIndex = viewPages.firstIndex(of: viewController),
              currentIndex != viewPages.count - 1 else { return nil }
        
        return viewPages[currentIndex + 1]
    }
}
