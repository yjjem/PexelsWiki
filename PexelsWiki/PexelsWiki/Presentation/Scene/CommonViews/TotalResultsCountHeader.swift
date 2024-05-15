//
//  FoundResultsCountHeader.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import UIKit

final class TotalResultsCountHeader: UICollectionReusableView {
    
    // MARK: Property(s)
    
    private let resultsCountContainingLabel = UILabel()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
        configureStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function(s)
    
    func addFoundResultsCount(_ count: Int) {
        resultsCountContainingLabel.text = "Found \(count) results"
    }
    
    // MARK: Private Function(s)
    
    private func configureStyle() {
        resultsCountContainingLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
    }
    
    private func configureHierarchy() {
        addSubview(resultsCountContainingLabel)
    }
    
    private func configureConstraints() {
        let inset: CGFloat = 3
        resultsCountContainingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultsCountContainingLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            resultsCountContainingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            resultsCountContainingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            resultsCountContainingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}
