//
//  PhotoDetailViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class PhotoDetailViewController: UIViewController {
    
    // MARK: Property(s)
    
    var viewModel: PhotoDetailViewModel?
    
    private var imageViewHeightConstraint: NSLayoutConstraint?
    private var infoStackBottomConstraint: NSLayoutConstraint?
    
    private let contentScrollView = UIScrollView()
    private let scrollContent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private let imageView = StretchableImageView()
    private let informationStack: UIStackView = {
        let stackView = UIStackView()
        stackView.directionalLayoutMargins = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let titleLabel: UILabel = UILabel()
    private let userNameLabel: UILabel = UILabel()
    private let resolutionLabel: UILabel = UILabel()
    
    private let buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    private let visitProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.right.square"), for: .normal)
        button.setTitle("Visit Profile", for: .normal)
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.down.doc.fill"), for: .normal)
        button.setTitle("Download", for: .normal)
        return button
    }()
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = contentScrollView
        contentScrollView.backgroundColor = .systemBackground
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.alwaysBounceVertical = true
        contentScrollView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarchy()
        configureConstraints()
        configureStyle()
        bindViewModel()
        viewModel?.startFetching()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.loadedPhotoData = { [weak self] photoData in
            DispatchQueue.main.async {
                self?.imageView.addImageData(photoData)
            }
        }
        
        viewModel?.loadedPhotoInformation = { [weak self] photoInformation in
            DispatchQueue.main.async {
                self?.titleLabel.text = photoInformation.title
                self?.userNameLabel.text = photoInformation.userName
                self?.resolutionLabel.text = photoInformation.resolution
            }
        }
    }
    
    private func configureViewHierarchy() {
        contentScrollView.addSubview(scrollContent)
        
        scrollContent.addArrangedSubview(imageView)
        scrollContent.addArrangedSubview(informationStack)
        
        informationStack.addArrangedSubview(titleLabel)
        informationStack.addArrangedSubview(userNameLabel)
        informationStack.addArrangedSubview(resolutionLabel)
        informationStack.addArrangedSubview(buttonsStack)
        
        buttonsStack.addArrangedSubview(visitProfileButton)
        buttonsStack.addArrangedSubview(downloadButton)
    }
    
    private func configureConstraints() {
        let scrollViewContentGuide = contentScrollView.contentLayoutGuide
        scrollContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollContent.topAnchor.constraint(equalTo: scrollViewContentGuide.topAnchor),
            scrollContent.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            scrollContent.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            scrollContent.bottomAnchor.constraint(equalTo: scrollViewContentGuide.bottomAnchor),
            scrollContent.heightAnchor.constraint(equalTo: scrollViewContentGuide.heightAnchor)
        ])
        
        let imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 400)
        self.imageViewHeightConstraint = imageViewHeightConstraint
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            imageViewHeightConstraint
        ])
        
        let buttonSize: CGFloat = 37
        NSLayoutConstraint.activate([
            downloadButton.heightAnchor.constraint(equalToConstant: buttonSize),
            visitProfileButton.heightAnchor.constraint(equalToConstant: buttonSize),
        ])
    }
    
    private func configureStyle() {
        scrollContent.backgroundColor = .systemBackground
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        userNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        resolutionLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        let buttons: [UIButton] = [visitProfileButton, downloadButton]
        buttons.forEach { button in
            button.backgroundColor = UIColor.pexelsGreen
            button.layer.cornerRadius = 11
            button.layer.cornerCurve = .circular
            button.layer.masksToBounds = true
            button.tintColor = .white
        }
        informationStack.setCustomSpacing(30, after: resolutionLabel)
    }
}

// MARK: UIScrollViewDelegate

extension PhotoDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateImageViewHeight(in: scrollView)
        resetImageViewStretchScale()
    }
    
    private func updateImageViewHeight(in scrollView: UIScrollView) {
        let minHeight: CGFloat = 400
        let maxHeight: CGFloat = 760
        let animationDuration: TimeInterval = 0.6
        let translationY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        
        if translationY < 0 {
            UIView.animate(withDuration: animationDuration) {
                self.imageViewHeightConstraint?.constant = minHeight
                self.view.layoutIfNeeded()
            }
        } else if translationY > 0 {
            UIView.animate(withDuration: animationDuration) {
                self.imageViewHeightConstraint?.constant = maxHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func resetImageViewStretchScale() {
        imageView.setZoomScale(1, animated: true)
    }
}
