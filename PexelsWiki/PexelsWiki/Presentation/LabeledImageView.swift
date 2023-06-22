//
//  UserInfoView.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class LabeledImageView: UIImageView {
    
    private let userIconView: UIImageView = {
        let defaultUserImage = UIImage(systemName: "person.fill")
        let view = UIImageView(image: defaultUserImage)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.tintColor = .label
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let informationStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.spacing = 5
        stack.layoutMargins = .init(top: 5, left: 10, bottom: 5, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    convenience init() {
        self.init(frame: .zero)
        configureView()
    }
    
    func add(userName: String) {
        self.userNameLabel.text = userName
    }
    
    func configureView() {
        informationStackView.addArrangedSubview(userIconView)
        informationStackView.addArrangedSubview(userNameLabel)
        addSubview(informationStackView)
        
        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            informationStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            informationStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            informationStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            informationStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1)
        ])
    }
}
