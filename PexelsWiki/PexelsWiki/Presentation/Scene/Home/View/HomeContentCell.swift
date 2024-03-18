//
//  HomeContentCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class HomeContentCell: UICollectionViewCell {
    
    // MARK: Property(s)
    
    private var imageRequest: Cancellable?
    private let imageView: UIImageView = UIImageView()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageRequest?.cancel()
    }
    
    // MARK: Function(s)
    
    func configure(using viewModel: HomeContentCellViewModel) {
        imageRequest = ImageLoadManager.fetchCachedImageDataElseLoad(
            urlString: viewModel.imageURL
        ) { [weak self] response in
            guard let self else { return }
            if case .success(let imageData) = response {
                if let image = UIImage(data: imageData) {
                    imageView.image = image
                }
            }
        }
    }
    
    // MARK: Private Function(s)
    
    private func configureConstraints() {
        contentView.addSubview(imageView)
        contentView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
