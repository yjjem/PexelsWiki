//
//  VideoDurationFormatter.swift
//  PexelsWiki
//
//  Copyright (c) 2024 Jeremy All rights reserved.
    

import Foundation

struct VideoDurationFormatter {
    
    // MARK: Property(s)
    
    let duration: Int
    
    private var durationInterval: TimeInterval { TimeInterval(duration) }
    private let formatter = DateComponentsFormatter()
    
    // MARK: Function(s)
    
    func formattedString() -> String? {
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: durationInterval)
    }
}
