//
//  PhotoContentViewModel.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

struct PhotoContentCellViewModel: Hashable {
    let userName: String
    let imageURLString: String
    let imageID: Int
    let imageWidth: Int
    let imageHeight: Int
}
