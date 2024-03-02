//
//  StretchHeaderViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import UIKit

class StretchHeaderViewController: UIViewController {
    
    // MARK: Property(s)
    
    var stretchMinHeight: CGFloat = 300
    var stretchMaxHeight: CGFloat {
        return view.safeAreaLayoutGuide.layoutFrame.height
    }
    var stretchAnimationDuration: TimeInterval = 0.6
    
    var contentViews: [UIView] = []
    var viewToStretch: UIView? {
        return contentViews.first
    }
    
    let scrollView = UIScrollView()
    let scrollContent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private var viewToStretchHeightConstraint: NSLayoutConstraint?
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = scrollView
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollContent()
        configureContentViews()
        configureStretchingView()
    }
    
    // MARK: Private Function(s)
    
    private func configureContentViews() {
        contentViews.forEach { scrollContent.addArrangedSubview($0) }
    }
    
    private func configureScrollContent() {
        scrollView.addSubview(scrollContent)
        scrollContent.translatesAutoresizingMaskIntoConstraints = false
        scrollContent.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            scrollContent.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func configureStretchingView() {
        guard let viewToStretch else { return }
        
        let stretchHeightConstraint = viewToStretch.heightAnchor
            .constraint(equalToConstant: stretchMinHeight)
        NSLayoutConstraint.activate([
            viewToStretch.topAnchor.constraint(equalTo: scrollContent.topAnchor),
            viewToStretch.widthAnchor.constraint(equalTo: scrollContent.widthAnchor),
            stretchHeightConstraint
        ])
        self.viewToStretchHeightConstraint = stretchHeightConstraint
    }
}

// MARK: UIScrollViewDelegate

extension StretchHeaderViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateTopViewHeight(in: scrollView)
    }
    
    private func updateTopViewHeight(in scrollView: UIScrollView) {
        let translationY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        
        UIView.animate(withDuration: stretchAnimationDuration) {
            if translationY < 0 {
                self.viewToStretchHeightConstraint?.constant = self.stretchMinHeight
                self.view.layoutIfNeeded()
            } else if translationY > 0 {
                self.viewToStretchHeightConstraint?.constant = self.stretchMaxHeight
                self.view.layoutIfNeeded()
            }
        }
    }
}
