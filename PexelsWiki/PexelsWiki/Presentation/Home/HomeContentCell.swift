//
//  HomeContentCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class HomeContentCell: UICollectionViewCell {
    
    // MARK: Variable(s)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let userInfoView: UserInfoView = {
        let userInfoView = UserInfoView()
        return userInfoView
    }()
    
    private var contentLoad: Cancellable?
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        contentLoad?.cancel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        contentLoad?.cancel()
    }
    
    // MARK: Function(s)
    
    func configure(using viewModel: HomeContentCellViewModel) {
        
        userInfoView.setupUserName(using: viewModel.userName)
        
        contentLoad = ImageLoadManager.fetchCachedImageDataElseLoad(
            urlString: viewModel.imageURL
        ) { [weak self] response in
            
            guard let self else { return }
            
            response.onComplete(self.imageView.addImage)
        }
    }
    
    // MARK: Private Function(s)
    
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
