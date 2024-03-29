//
//  VideoDetailViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit
import AVKit

final class VideoDetailViewController: StretchHeaderViewController {
    
    // MARK: Property(s)
    
    var viewModel: VideoDetailViewModel?
    weak var delegate: DetailViewControllerDelegate?
    
    private var playerStatusObserving: NSKeyValueObservation?
    private let playerViewController = AVPlayerViewController()
    
    private let informationStack: UIStackView = {
        let stackView = UIStackView()
        stackView.directionalLayoutMargins = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
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
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        configureHierarchy()
        super.viewDidLoad()
        configureStyle()
        configureConstraints()
        configurePlayerStatusObservation()
        configureButtons()
        bindViewModel()
        viewModel?.startFetchingVideoItem()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        
        viewModel?.fetchedVideo = { [weak self] video in
            guard let url = URL(string: video.url) else { return }
            DispatchQueue.main.async {
                let player = AVPlayer(url: url)
                self?.playerViewController.player = player
                self?.userNameLabel.text = video.userName
                self?.resolutionLabel.text = video.resolution
            }
        }
        
        viewModel?.profileIsAvailable = { [weak self] in
            DispatchQueue.main.async {
                self?.visitProfileButton.isEnabled = true
            }
        }
    }
    
    private func configurePlayerStatusObservation() {
        playerStatusObserving = playerViewController.observe(\.isReadyForDisplay) { playerView, _ in
            DispatchQueue.main.async {
                playerView.player?.play()
            }
        }
    }
    
    private func configureHierarchy() {
        addChild(playerViewController)
        contentViews = [playerViewController.view, informationStack]
        
        informationStack.addArrangedSubview(userNameLabel)
        informationStack.addArrangedSubview(resolutionLabel)
        informationStack.addArrangedSubview(buttonsStack)
        
        buttonsStack.addArrangedSubview(visitProfileButton)
    }
    
    private func configureStyle() {
        playerViewController.view.backgroundColor = .systemFill
        userNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        resolutionLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        visitProfileButton.asPexelsButton()
        informationStack.setCustomSpacing(30, after: resolutionLabel)
    }
    
    private func configureConstraints() {
        let buttonSize: CGFloat = 37
        NSLayoutConstraint.activate([
            visitProfileButton.heightAnchor.constraint(equalToConstant: buttonSize),
        ])
    }
    
    // MARK: Action(s)
    
    @objc private func didTapVisitProfileButton() {
        if let viewModel, let userProfileURL = viewModel.userProfileURL {
            delegate?.didRequestUserProfile(userProfileURL)
        }
    }
    
    private func configureButtons() {
        visitProfileButton.addTarget(
            self, action: #selector(didTapVisitProfileButton),
            for: .touchUpInside
        )
    }
}
