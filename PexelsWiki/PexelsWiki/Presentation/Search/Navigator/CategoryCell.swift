//
//  CategoryCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class CategoryCell: UICollectionViewCell {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(using category: Category) {
        let image = UIImage(named: category.name)
        imageView.image = image
        categoryLabel.text = category.name
        categoryName = category.name
    }
    
    private func configureLayoutConstraints() {
        imageView.addSubview(categoryLabel)
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}
