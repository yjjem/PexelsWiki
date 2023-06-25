//
//  VideoContentCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class VideoContentCell: UICollectionViewCell {
    
    private let videoView: VideoPlayerView = {
        let videoView = VideoPlayerView()
        return videoView
    }()
    
    private let userInfoView: UserInfoView = {
        let userInfoView = UserInfoView()
        return userInfoView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewLayoutConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(using viewModel: VideoContentCellViewModel) {
        videoView.loadVideo(from: viewModel.videoURLString)
        userInfoView.add(userName: viewModel.userName)
    }
    
    private func configureViewLayoutConstraints() {
        addSubview(videoView)
        addSubview(userInfoView)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            videoView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9)
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
