//
//  CategoryCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class CategoryCell: UICollectionViewCell {
    
    // MARK: Property(s)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 9
        imageView.layer.cornerCurve = .circular
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function(s)
    
    func configure(using category: RecommendedCategory) {
        let image = UIImage(named: category.imageName)
        imageView.image = image
        categoryLabel.text = category.capitalizedName
    }
    
    // MARK: Private Function(s)
    
    private func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(categoryLabel)
    }
    
    private func configureLayoutConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
