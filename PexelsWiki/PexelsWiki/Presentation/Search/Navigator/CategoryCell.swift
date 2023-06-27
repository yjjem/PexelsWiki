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
        return label
    }()
    
    var categoryName: String = ""
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function(s)
    
    func configure(using category: Category) {
        let image = UIImage(named: category.name)
        imageView.image = image
        categoryLabel.text = category.name
        categoryName = category.name
    }
    
    // MARK: Private Function(s)
    
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
            categoryLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}
