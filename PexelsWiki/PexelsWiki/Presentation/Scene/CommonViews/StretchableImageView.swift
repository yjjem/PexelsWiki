//
//  StretchableImageView.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.


import UIKit

final class StretchableImageView: UIScrollView {
    
    // MARK: Property(s)
    
    private let imageView: UIImageView = UIImageView()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
        configureScrollView()
        configureDoubleTapGesture()
        configureStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function(s)
    
    func addImageData(_ imageData: Data) {
        let image = UIImage(data: imageData)
        imageView.image = image
    }
    
    // MARK: Private Function(s)
    
    @objc private func didDoubleTap() {
        if zoomScale == maximumZoomScale {
            setZoomScale(minimumZoomScale, animated: true)
        } else if zoomScale == minimumZoomScale {
            setZoomScale(maximumZoomScale, animated: true)
        }
    }
    
    private func configureDoubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.addTarget(self, action: #selector(didDoubleTap))
        self.addGestureRecognizer(doubleTapGesture)
    }
    
    private func configureScrollView() {
        backgroundColor = .tertiarySystemGroupedBackground
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        minimumZoomScale = 1
        maximumZoomScale = 3
        bounces = false
        delegate = self
    }
    
    private func configureHierarchy() {
        addSubview(imageView)
    }
    
    private func configureConstraints() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func configureStyle() {
        backgroundColor = .secondarySystemFill
    }
}

extension StretchableImageView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) { }
}
