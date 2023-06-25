//
//  VideoPlayable.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit
import AVKit

protocol VideoPlayable: UIView {
    associatedtype PlayerState
    
    var playerState: PlayerState { get set }
    
    func playVideo()
    func pauseVideo()
    func stateDidChange()
}

extension VideoPlayable {
    
    var player: AVPlayer? {
        get{
            playerLayer?.player
        }
        set {
            playerLayer?.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer? {
        guard let layer = layer as? AVPlayerLayer else { return nil }
        layer.videoGravity = .resizeAspectFill
        return layer
    }
    
    func playVideo() {
        player?.play()
    }
    
    func pauseVideo() {
        player?.pause()
    }
    
}
