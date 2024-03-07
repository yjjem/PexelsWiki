//
//  ImageSearchCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class PhotoContentCell: UICollectionViewCell {
    
    // MARK: Property(s)
    
    private let photoThumbnailView: UIImageView = UIImageView()
    private var contentLoad: Cancellable?
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLoad?.cancel()
    }
    
    // MARK: Function(s)
    
    func configure(using viewModel: PhotoContentCellViewModel) {
        
        // TODO: 셀이 로딩 로직을 모르도록 수정할 것
        
        contentLoad = ImageLoadManager.fetchCachedImageDataElseLoad(
            urlString: viewModel.imageURLString
        ) { [weak self] response in
            
            guard let self else { return }
            _ = response.map(self.photoThumbnailView.addImage)
        }
    }
    
    // MARK: Private Function(s)
    
    private func configureHierarchy() {
        contentView.addSubview(photoThumbnailView)
    }
    
    private func configureLayoutConstraints() {
        photoThumbnailView.contentMode = .scaleAspectFill
        photoThumbnailView.translatesAutoresizingMaskIntoConstraints = false
        photoThumbnailView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            photoThumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoThumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoThumbnailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoThumbnailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            photoThumbnailView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
//            photoThumbnailView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
}
