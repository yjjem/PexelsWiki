//
//  CategoryCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class CategoryCell: UICollectionViewCell {
    
    // MARK: Variable(s)
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayoutConstraints()
        configureLayerAppearance()
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
    
    private func configureLayerAppearance() {
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    private func configureLayoutConstraints() {
        imageView.addSubview(categoryLabel)
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.widthAnchor.constraint(equalToConstant: 90),
            categoryLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}
