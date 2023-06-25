//
//  VideoPlayerView.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit
import AVKit

final class VideoPlayerView: UIView, VideoPlayable {
    
    enum PlayerState {
        case active
        case inactive
    }
    
    var playerState: PlayerState = .inactive {
        didSet {
            stateDidChange()
        }
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    func loadVideo(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        player = makePlayer(with: url)
    }
    
    func stateDidChange() {
        switch playerState {
        case .active: playVideo()
        case .inactive: pauseVideo()
        }
    }
}
