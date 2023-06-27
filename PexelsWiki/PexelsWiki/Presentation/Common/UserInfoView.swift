//
//  UserInfoView.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class UserInfoView: UIView {
    
    // MARK: View(s)
    
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
        stack.layoutMargins = .init(top: 5, left: 10, bottom: 5, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 5
        return stack
    }()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function(s)
    
    func add(userName: String) {
        userNameLabel.text = userName
    }
    
    // MARK: Private Function(s)
    
    private func configureLayoutConstraints() {
        informationStackView.addArrangedSubview(userIconView)
        informationStackView.addArrangedSubview(userNameLabel)
        addSubview(informationStackView)
        
        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            informationStackView.topAnchor.constraint(equalTo: topAnchor),
            informationStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            informationStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            informationStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
