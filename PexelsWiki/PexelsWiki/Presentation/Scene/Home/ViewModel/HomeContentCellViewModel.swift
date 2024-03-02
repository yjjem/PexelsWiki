//
//  HomeContentCellViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

struct HomeContentCellViewModel: Hashable {
    let userName: String
    let userProfileURL: String
    let imageTitle: String
    let imageID: Int
    let imageURL: String
    let imageWidth: Int
    let imageHeight: Int
    let resolutionString: String
}
