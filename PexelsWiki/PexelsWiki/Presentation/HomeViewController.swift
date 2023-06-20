//
//  ViewController.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

final class HomeViewController: UIViewController {
    
    private let contentCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        return collection
    }()

    override func loadView() {
        super.loadView()
        
        configureView()
        addContentCollectionView()
    }
    
    func configureView() {
        view.backgroundColor = .systemGray6
    }
    
    func addContentCollectionView() {
        
        view.addSubview(contentCollectionView)
        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            contentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

