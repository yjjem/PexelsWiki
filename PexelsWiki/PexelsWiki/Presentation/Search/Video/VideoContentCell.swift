//
//  VideoContentCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class VideoContentCell: UICollectionViewCell {
    
    // MARK: Variable(s)
    
    private let videoView: VideoPlayerView = {
        let videoView = VideoPlayerView()
        videoView.allowsVideoSounds = false
        return videoView
    }()
    
    private let userInfoView: UserInfoView = {
        let userInfoView = UserInfoView()
        return userInfoView
    }()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        videoView.prepareForReuse()
    }
    
    // MARK: Function(s)
    
    func play() {
        videoView.playVideo()
    }
    
    func pause() {
        videoView.pauseVideo()
    }
    
    func configure(using viewModel: VideoContentCellViewModel) {
        videoView.fetchVideo(using: viewModel.videoURLString)
        userInfoView.setupUserName(using: viewModel.userName)
    }
    
    // MARK: Private Function(s)
    
    private func configureViewLayoutConstraints() {
        contentView.addSubview(videoView)
        contentView.addSubview(userInfoView)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            videoView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            videoView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: videoView.bottomAnchor),
            userInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

fileprivate extension VideoPlayerView {
    
    func prepareForReuse() {
        videoAsset?.cancelLoading()
        videoAsset = nil
        playerItem = nil
    }
}
