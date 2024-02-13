//
//  HomeContentCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class HomeContentCell: UICollectionViewCell {
    
    // MARK: Property(s)
    
    private var contentLoad: Cancellable?
    
    private let imageView: UIImageView = UIImageView()
    private let userInfoView: UserInfoView = UserInfoView()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLoad?.cancel()
    }
    
    // MARK: Function(s)
    
    func configure(using viewModel: HomeContentCellViewModel) {
        
        userInfoView.setupUserName(using: viewModel.userName)
        
        // TODO: 셀이 로딩 로직을 모르도록 수정할 것
        
        contentLoad = ImageLoadManager.fetchCachedImageDataElseLoad(
            urlString: viewModel.imageURL
        ) { [weak self] response in
            
            guard let self else { return }
            
            _ = response.map(self.imageView.addImage)
        }
    }
    
    // MARK: Private Function(s)
    
    private func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(userInfoView)
    }
    
    private func configureViews() {
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
