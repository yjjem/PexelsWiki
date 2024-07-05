//
//  VideoPlayerView.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import AVKit

class VideoPlayerView: UIView {
    
    // MARK: Property(s)
    
    var playerItem: AVPlayerItem?
    var allowsVideoSounds: Bool = true
    
    var player: AVPlayer? {
        didSet {
            playerLayer?.player = player
        }
    }
    
    var playerLayer: AVPlayerLayer? {
        return layer as? AVPlayerLayer
    }
    
    // MARK: Override(s)
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    // MARK: Function(s)
    
    func fetchVideo(using urlString: String) {
        
        guard let videoURL = URL(string: urlString) else { return }
        let playerItem = AVPlayerItem(url: videoURL)
        self.playerItem = playerItem
        
        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            makePlayer(item: playerItem)
        }
    }
    
    func playVideo() {
        if let player, player.currentItem?.status == .readyToPlay {
            player.play()
        }
    }
    
    func pauseVideo() {
        if let player, player.currentItem?.status == .readyToPlay {
            player.pause()
        }
    }
    
    // MARK: Private Function(s)
    
    private func makePlayer(item: AVPlayerItem) {
        let videoPlayer = AVPlayer(playerItem: playerItem)
        videoPlayer.isMuted = allowsVideoSounds
        player = videoPlayer
    }
}
