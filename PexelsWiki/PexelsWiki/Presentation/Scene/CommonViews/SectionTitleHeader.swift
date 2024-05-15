//
//  SectionTitleHeader.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import UIKit

final class SectionTitleHeader: UICollectionReusableView {
    
    // MARK: Property(s)
    
    private let titleLabel = UILabel()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
        configureTitleStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function(s)
    
    func addTitle(_ newTitle: String) {
        titleLabel.text = newTitle
    }
    
    
    // MARK: Private Function(s)
    
    private func configureTitleStyle() {
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    private func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
