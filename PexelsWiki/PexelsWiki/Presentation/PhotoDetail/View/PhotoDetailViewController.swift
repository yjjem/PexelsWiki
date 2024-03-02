//
//  PhotoDetailViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class PhotoDetailViewController: StretchHeaderViewController {
    
    // MARK: Property(s)
    
    var viewModel: PhotoDetailViewModel?
    
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
        super.loadView()
        contentViews = [imageView, informationStack]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarchy()
        configureConstraints()
        configureStyle()
        bindViewModel()
        viewModel?.startFetching()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        imageView.setZoomScale(1, animated: true)
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
        informationStack.addArrangedSubview(titleLabel)
        informationStack.addArrangedSubview(userNameLabel)
        informationStack.addArrangedSubview(resolutionLabel)
        informationStack.addArrangedSubview(buttonsStack)
        
        buttonsStack.addArrangedSubview(visitProfileButton)
        buttonsStack.addArrangedSubview(downloadButton)
    }
    
    private func configureConstraints() {
        let buttonSize: CGFloat = 37
        NSLayoutConstraint.activate([
            downloadButton.heightAnchor.constraint(equalToConstant: buttonSize),
            visitProfileButton.heightAnchor.constraint(equalToConstant: buttonSize),
        ])
    }
    
    private func configureStyle() {
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
