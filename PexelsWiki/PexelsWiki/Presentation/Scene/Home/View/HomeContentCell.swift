//
//  HomeContentCell.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class HomeContentCell: UICollectionViewCell {
    
    // MARK: Property(s)
    
    private var currentHeightConstraint: NSLayoutConstraint?
    private var imageRequest: Cancellable?
    
    private let contentStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let imageView: UIImageView = UIImageView()

    private let informationStack: UIStackView = {
        let stackView = UIStackView()
        stackView.directionalLayoutMargins = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    private let titleLabel: UILabel = UILabel()
    private let userNameLabel: UILabel = UILabel()
    private let resolutionLabel: UILabel = UILabel()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
        configureLabelAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageRequest?.cancel()
        currentHeightConstraint?.isActive = false
        titleLabel.isHidden = false
    }
    
    // MARK: Function(s)
    
    func configure(using viewModel: HomeContentCellViewModel) {
        configureImageHeightByRatio(width: viewModel.imageWidth, height: viewModel.imageHeight)
        configureInformationValues(
            title: viewModel.imageTitle,
            userName: viewModel.userName,
            resolution: viewModel.resolutionString
        )
        
        // TODO: 셀이 로딩 로직을 모르도록 수정할 것
        imageRequest = ImageLoadManager.fetchCachedImageDataElseLoad(
            urlString: viewModel.imageURL
        ) { [weak self] response in
            if case .success(let imageData) = response {
                let image = UIImage(data: imageData)
                self?.imageView.image = image
            }
        }
    }
    
    // MARK: Private Function(s)
    
    private func configureInformationValues(title: String, userName: String, resolution: String) {
        if title.isEmpty {
            titleLabel.isHidden = true
        } else {
            titleLabel.isHidden = false
            titleLabel.text = title.prefix(1).capitalized + title.dropFirst()
        }
        resolutionLabel.text = resolution
        userNameLabel.text = userName
    }
    
    private func configureImageHeightByRatio(width: Int, height: Int) {
        let heightRatio: CGFloat = CGFloat(height) / CGFloat(width)
        let newHeightConstraint = imageView.heightAnchor.constraint(
            equalTo: imageView.widthAnchor,
            multiplier: heightRatio
        )
        newHeightConstraint.isActive = true
        currentHeightConstraint = newHeightConstraint
        imageView.needsUpdateConstraints()
    }
    
    private func configureLabelAttributes() {
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        userNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        resolutionLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
    }
    
    private func configureHierarchy() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(informationStack)
        let infoViews: [UIView] = [titleLabel, userNameLabel, resolutionLabel]
        infoViews.forEach { informationStack.addArrangedSubview($0) }
    }
    
    private func configureConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
}
