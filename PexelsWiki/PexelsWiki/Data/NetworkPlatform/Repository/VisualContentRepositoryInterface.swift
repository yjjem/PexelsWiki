//
//  VisualContentRepositoryInterface.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

protocol VisualContentRepositoryInterface: SearchPhotosPort,
                                            SpecificPhotoPort,
                                            SearchVideosPort,
                                            SpecificVideoPort { }
