//
//  CollectionMediaPreviewCell.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class CollectionMediaPreviewCell: UICollectionViewCell {
    
    // MARK: Property(s)
    
    let imageView: UIImageView = .init()
    private let videoMarkingImageView: UIImageView = .init()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoMarkingImageView.removeFromSuperview()
    }
    
    // MARK: Function(s)
    
    func markAsVideo() {
        addVideoMark()
    }
    
    // MARK: Private Function(s)
    
    private func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    private func configureLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func addVideoMark() {
        imageView.addSubview(videoMarkingImageView)
        let spacingConstant: CGFloat = 5
        videoMarkingImageView.tintColor = .white
        videoMarkingImageView.image = UIImage(systemName: "play.fill")
        videoMarkingImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoMarkingImageView.topAnchor.constraint(
                equalTo: imageView.topAnchor,
                constant: spacingConstant
            ),
            videoMarkingImageView.trailingAnchor.constraint(
                equalTo: imageView.trailingAnchor,
                constant: -spacingConstant
            )
        ])
    }
}
