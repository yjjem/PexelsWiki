//
//  PhotoDetailViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class PhotoDetailViewController: UIViewController {
    
    // MARK: Property(s)
    
    private var imageViewHeightConstraint: NSLayoutConstraint?
    private var infoStackBottomConstraint: NSLayoutConstraint?
    
    private let contentScrollView = UIScrollView()
    private let imageView = StretchableImageView()
    private let informationStack: UIStackView = {
        let stackView = UIStackView()
        stackView.directionalLayoutMargins = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    private let titleLabel: UILabel = UILabel()
    private let userNameLabel: UILabel = UILabel()
    private let resolutionLabel: UILabel = UILabel()
    
    private let buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.axis = .horizontal
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
        contentScrollView.contentInsetAdjustmentBehavior = .never
        contentScrollView.backgroundColor = .tertiarySystemFill
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.contentSize.height = 1200
        contentScrollView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarchy()
        configureConstraints()
        configureStyle()
    }
    
    // MARK: Private Function(s)
    
    private func configureStyle() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        userNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        resolutionLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        let buttons: [UIButton] = [visitProfileButton, downloadButton]
        buttons.forEach { button in
            button.backgroundColor = UIColor.pexelsGreen
            button.layer.cornerRadius = 15
            button.layer.cornerCurve = .circular
            button.layer.masksToBounds = true
            button.tintColor = .white
        }
    }
    
    private func configureViewHierarchy() {
        contentScrollView.addSubview(imageView)
        contentScrollView.addSubview(informationStack)
        
        informationStack.addArrangedSubview(titleLabel)
        informationStack.addArrangedSubview(userNameLabel)
        informationStack.addArrangedSubview(resolutionLabel)
        informationStack.addArrangedSubview(buttonsStack)
        
        buttonsStack.addArrangedSubview(visitProfileButton)
        buttonsStack.addArrangedSubview(downloadButton)
    }
    
    private func configureConstraints() {
        let defaultImageViewHeightConstraint = imageView.heightAnchor.constraint(
            equalToConstant: 800
        )
        imageViewHeightConstraint = defaultImageViewHeightConstraint
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: contentScrollView.safeAreaLayoutGuide.topAnchor
            ),
            imageView.leadingAnchor.constraint(
                equalTo: contentScrollView.contentLayoutGuide.leadingAnchor
            ),
            imageView.trailingAnchor.constraint(
                equalTo: contentScrollView.contentLayoutGuide.trailingAnchor
            ),
            imageView.widthAnchor.constraint(
                equalTo: contentScrollView.widthAnchor
            ),
            defaultImageViewHeightConstraint
        ])
        
        informationStack.translatesAutoresizingMaskIntoConstraints = false
        let scrollBottom = informationStack.bottomAnchor.constraint(
            lessThanOrEqualTo: contentScrollView.contentLayoutGuide.bottomAnchor,
            constant: -300
        )
        infoStackBottomConstraint = scrollBottom
        NSLayoutConstraint.activate([
            scrollBottom,
            informationStack.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor),
            informationStack.leadingAnchor.constraint(
                equalTo: contentScrollView.contentLayoutGuide.leadingAnchor
            ),
            informationStack.trailingAnchor.constraint(
                equalTo: contentScrollView.contentLayoutGuide.trailingAnchor
            )
        ])
        
        let buttonSize: CGFloat = 50
        NSLayoutConstraint.activate([
            downloadButton.heightAnchor.constraint(equalToConstant: buttonSize),
            visitProfileButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
    }
}

// MARK: UIScrollViewDelegate

extension PhotoDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeightConstraints(using: scrollView)
        resetImageViewStretchScale()
    }
    
    private func updateHeightConstraints(using scrollView: UIScrollView) {
        guard let imageViewHeightConstraint, let infoStackBottomConstraint else { return }
        let minHeight: CGFloat = 300
        let maxHeight: CGFloat = 800
        let maxInfoShrinkValue: CGFloat = -100
        let offsetY = scrollView.contentOffset.y
        let shrinkHeight = maxHeight - offsetY
        
        if (minHeight..<maxHeight).contains(shrinkHeight) {
            
            guard shrinkHeight >= minHeight else { return }
            imageViewHeightConstraint.constant = shrinkHeight
            
            guard -shrinkHeight == maxInfoShrinkValue else { return }
            infoStackBottomConstraint.constant = -shrinkHeight
        }
    }
    
    private func resetImageViewStretchScale() {
        imageView.setZoomScale(1, animated: true)
    }
}
