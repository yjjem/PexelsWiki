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
    private let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.down.doc.fill"), for: .normal)
        button.setTitle("Download", for: .normal)
        return button
    }()
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        configureHierarchy()
        super.viewDidLoad()
        configureStyle()
        configureConstraints()
        configurePlayerStatusObservation()
        bindViewModel()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.fetchedVideoItem = { [weak self] videoItem in
            guard let url = URL(string: videoItem.files[0].url) else { return }
            
            DispatchQueue.main.async {
                let player = AVPlayer(url: url)
                self?.playerViewController.player = player
                self?.userNameLabel.text = videoItem.userName
                self?.resolutionLabel.text = videoItem.resolution
            }
        }
        
        viewModel?.profileIsAvailable = { [weak self] in
            DispatchQueue.main.async {
                self?.visitProfileButton.isEnabled = true
            }
        }
        
        viewModel?.startFetchingVideoItem()
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
        buttonsStack.addArrangedSubview(downloadButton)
    }
    
    private func configureStyle() {
        userNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        resolutionLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        let buttons: [UIButton] = [visitProfileButton, downloadButton]
        buttons.forEach { $0.asPexelsButton() }
        informationStack.setCustomSpacing(30, after: resolutionLabel)
    }
    
    private func configureConstraints() {
        let buttonSize: CGFloat = 37
        NSLayoutConstraint.activate([
            downloadButton.heightAnchor.constraint(equalToConstant: buttonSize),
            visitProfileButton.heightAnchor.constraint(equalToConstant: buttonSize),
        ])
    }
}
