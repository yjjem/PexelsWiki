//
//  VisualContentRepositoryInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

protocol VisualContentRepositoryInterface: CuratedPhotosPort,
                                            SearchPhotosPort,
                                            SpecificPhotoPort,
                                            SearchVideosPort,
                                            SpecificVideoPort { }
