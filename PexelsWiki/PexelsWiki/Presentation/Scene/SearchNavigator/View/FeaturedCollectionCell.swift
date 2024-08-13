//
//  FeaturedCollectionCell.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import UIKit

final class FeaturedCollectionCell: UICollectionViewCell {
    
    // MARK: Property(s)
    
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    private let mediaCountLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defineViewHierarchy()
        applyLayoutConstraints()
        applyCustomStyleConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.isHidden = false
    }
    
    // MARK: Function(s)
    
    func configure(using viewModel: FeaturedCollectionCellViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        mediaCountLabel.text = "\(viewModel.totalItems) Photos & Videos"
        
        if viewModel.description.isEmpty {
            descriptionLabel.isHidden = true
        }
    }
    
    // MARK: Private Function(s)
    
    private func defineViewHierarchy() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(mediaCountLabel)
        contentView.addSubview(stackView)
    }
    
    private func applyLayoutConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func applyCustomStyleConfigurations() {
        layer.backgroundColor = UIColor.label.cgColor
        layer.borderWidth = 1.0
        layer.cornerCurve = .continuous
        layer.cornerRadius = 8
        layer.masksToBounds = true
        contentView.backgroundColor = UIColor.tertiarySystemBackground
        
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.layoutMargins = .init(top: 5, left: 5, bottom: 5, right: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        titleLabel.numberOfLines = .zero
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = UIColor.label
        
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.textColor = UIColor.secondaryLabel
        
        mediaCountLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        mediaCountLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        mediaCountLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        mediaCountLabel.textAlignment = .left
        mediaCountLabel.numberOfLines = 1
        mediaCountLabel.textColor = UIColor.tertiaryLabel
    }
}
