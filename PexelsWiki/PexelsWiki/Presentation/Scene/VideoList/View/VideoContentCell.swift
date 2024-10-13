//
//  VideoContentCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class VideoContentCell: UICollectionViewCell {
    
    // MARK: Property(s)
    
    var imageRequest: Cancellable?
    let videoThumbnailView: UIImageView = UIImageView()
    let durationLabel: UILabel = UILabel()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
        configureStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageRequest?.cancel()
    }
    
    // MARK: Private Function(s)
    
    private func configureStyles() {
        durationLabel.textColor = .white
        durationLabel.font = .boldSystemFont(ofSize: 14)
        videoThumbnailView.contentMode = .scaleAspectFit
    }
    
    private func configureHierarchy() {
        contentView.addSubview(videoThumbnailView)
        videoThumbnailView.addSubview(durationLabel)
    }
    
    private func configureConstraints() {
        videoThumbnailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoThumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoThumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoThumbnailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            videoThumbnailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            videoThumbnailView.heightAnchor.constraint(greaterThanOrEqualTo: contentView.heightAnchor)
        ])
        
        let durationLabelSpacing: CGFloat = 5
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            durationLabel.bottomAnchor.constraint(
                equalTo: videoThumbnailView.bottomAnchor,
                constant: -durationLabelSpacing
            ),
            durationLabel.trailingAnchor.constraint(
                equalTo: videoThumbnailView.trailingAnchor,
                constant: -durationLabelSpacing
            ),
        ])
    }
}
