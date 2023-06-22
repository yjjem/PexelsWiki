//
//  HomeContentCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class HomeContentCell: UICollectionViewCell {
    
    private let labeledImageView: LabeledImageView = {
        let imageView = LabeledImageView()
        imageView.backgroundColor = .systemRed
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(using viewModel: HomeContentCellViewModel) {
        
        // TODO: Add Image Cache
        
        labeledImageView.add(userName: viewModel.userName)
    }
    
    private func configureViews() {
        
        contentView.addSubview(labeledImageView)
        
        labeledImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labeledImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            labeledImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labeledImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            labeledImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9)
        ])
    }
}
