//
//  VideoContentCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class VideoContentCell: UICollectionViewCell {
    
    // MARK: Variable(s)
    
    private let videoThumbnailView: UIImageView = UIImageView()
    private let durationLabel: UILabel = UILabel()
    private var imageRequest: Cancellable?
    
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
    
    // MARK: Function(s)
    
    func configure(using viewModel: VideoPreviewItem) {
        durationLabel.text = viewModel.duration.description
        imageRequest = ImageLoadManager.fetchCachedImageDataElseLoad(
            urlString: viewModel.thumbnailImage
        ) { [weak self] result in
            if case let .success(imageData) = result {
                self?.videoThumbnailView.image = UIImage(data: imageData)
            }
        }
    }
    
    // MARK: Private Function(s)
    
    private func configureStyles() {
        durationLabel.textColor = .white
        durationLabel.font = .boldSystemFont(ofSize: 14)
    }
    
    private func configureHierarchy() {
        contentView.addSubview(videoThumbnailView)
        videoThumbnailView.addSubview(durationLabel)
    }
    
    private func configureConstraints() {
        videoThumbnailView.contentMode = .scaleAspectFit
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
