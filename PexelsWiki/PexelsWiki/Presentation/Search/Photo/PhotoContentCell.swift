//
//  ImageSearchCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class PhotoContentCell: UICollectionViewCell {
    
    // MARK: Variable(s)
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let userInfoView: UserInfoView = {
        let userInfo = UserInfoView()
        return userInfo
    }()
    
    private var contentLoad: Cancellable?
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayoutConstraints()
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
    
    func configure(using viewModel: PhotoContentCellViewModel) {
        
        userInfoView.setupUserName(using: viewModel.userName)
        
        // TODO: 셀이 로딩 로직을 모르도록 수정할 것
        
        contentLoad = ImageLoadManager.fetchCachedImageDataElseLoad(
            urlString: viewModel.imageURLString
        ) { [weak self] response in
            
            guard let self else { return }
            _ = response.map(self.imageView.addImage)
        }
    }
    
    // MARK: Private Function(s)
    
    private func configureLayoutConstraints() {
        contentView.addSubview(imageView)
        contentView.addSubview(userInfoView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9)
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
