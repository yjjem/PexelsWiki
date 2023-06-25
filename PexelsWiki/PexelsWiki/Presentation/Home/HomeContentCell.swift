//
//  HomeContentCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class HomeContentCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let userInfoView: UserInfoView = {
        let userInfoView = UserInfoView()
        return userInfoView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    func configure(using viewModel: HomeContentCellViewModel) {
        
        // TODO: Add Image Cache
        guard let url = URL(string: viewModel.imageURL) else { return }
        imageView.load(url: url)
        userInfoView.add(userName: viewModel.userName)
    }
    
    private func configureViews() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(userInfoView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.95)
        ])
        
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            userInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension UIImageView {
    func load(url: URL) {
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
