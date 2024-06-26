//
//  PhotoDetailViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func didRequestUserProfile(_ userProfileURL: String)
    func didRequestSave(image: UIImage)
}

final class PhotoDetailViewController: StretchHeaderViewController {
    
    // MARK: Property(s)
    
    var viewModel: PhotoDetailViewModel?
    weak var delegate: DetailViewControllerDelegate?
    
    private let imageUtilityManager = ImageUtilityManager()
    private let stretchableView = StretchableImageView()
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
        button.isEnabled = false
        return button
    }()
    
    private let saveImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo.badge.arrow.down.fill"), for: .normal)
        button.setTitle("Save to Gallery", for: .normal)
        return button
    }()
    
    // MARK: Override(s)
    
    override func loadView() {
        super.loadView()
        contentViews = [stretchableView, informationStack]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarchy()
        configureConstraints()
        configureStyle()
        configureButtons()
        bindViewModel()
        viewModel?.startFetching()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        stretchableView.setZoomScale(1, animated: true)
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        
        viewModel?.fetchedPhotoItem = { [weak self] photo in
            DispatchQueue.main.async {
                self?.titleLabel.text = photo.title
                self?.userNameLabel.text = photo.userName
                self?.resolutionLabel.text = photo.resolution
                self?.imageUtilityManager.requestImage(
                    for: photo.url,
                    shouldCache: false
                ) { [stretchableView = self?.stretchableView] image in
                    guard let stretchableView else { return }
                    DispatchQueue.main.async {
                        UIView.transition(
                            with: stretchableView,
                            duration: 0.3,
                            options: [.transitionCrossDissolve, .allowUserInteraction]
                        ) {
                            stretchableView.imageView.image = image
                        }
                    }
                }
            }
        }
        
        viewModel?.profileIsAvailable = { [weak self] in
            DispatchQueue.main.async {
                self?.visitProfileButton.isEnabled = true
            }
        }
    }
    
    private func configureViewHierarchy() {
        informationStack.addArrangedSubview(titleLabel)
        informationStack.addArrangedSubview(userNameLabel)
        informationStack.addArrangedSubview(resolutionLabel)
        informationStack.addArrangedSubview(buttonsStack)
        
        buttonsStack.addArrangedSubview(visitProfileButton)
        buttonsStack.addArrangedSubview(saveImageButton)
    }
    
    private func configureConstraints() {
        let buttonSize: CGFloat = 37
        NSLayoutConstraint.activate([
            saveImageButton.heightAnchor.constraint(equalToConstant: buttonSize),
            visitProfileButton.heightAnchor.constraint(equalToConstant: buttonSize),
        ])
    }
    
    private func configureStyle() {
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        userNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        resolutionLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        let buttons: [UIButton] = [visitProfileButton, saveImageButton]
        buttons.forEach { button in
            button.backgroundColor = UIColor.pexelsGreen
            button.layer.cornerRadius = 11
            button.layer.cornerCurve = .circular
            button.layer.masksToBounds = true
            button.tintColor = .white
        }
        informationStack.setCustomSpacing(30, after: resolutionLabel)
    }
    
    private func configureButtons() {
        visitProfileButton.addTarget(
            self, action: #selector(didTapVisitProfileButton),
            for: .touchUpInside
        )
        saveImageButton.addTarget(
            self, action: #selector(didTapSaveImageButton),
            for: .touchUpInside
        )
    }
    
    // MARK: Action(s)
    
    @objc private func didTapVisitProfileButton() {
        if let viewModel, let userProfile = viewModel.photo?.userProfileURL {
            delegate?.didRequestUserProfile(userProfile)
        }
    }
    
    @objc private func didTapSaveImageButton() {
        if let image = stretchableView.imageView.image {
            delegate?.didRequestSave(image: image)
        }
    }
}
