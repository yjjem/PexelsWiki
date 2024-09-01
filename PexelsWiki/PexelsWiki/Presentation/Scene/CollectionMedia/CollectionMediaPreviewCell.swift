//
//  CollectionMediaPreviewCell.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import UIKit

final class CollectionMediaPreviewCell: UICollectionViewCell {

    // MARK: Property(s)
    
    let imageView: UIImageView = .init()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
