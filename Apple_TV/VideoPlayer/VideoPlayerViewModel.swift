//
//  VideoPlayerViewModel.swift
//  Apple_TV
//
//  Created by Streaming on 2025-03-31.
//

import Foundation
import SwiftUI
import AVKit

struct VideoData: Hashable {
    let id: Int
    let image: String
    let videoURL: String
    let title: String
    let description: String
}

class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isObserverAdded: Bool = false
    @Published var isPlayNextEpisode: Bool = false

    private var playerViewController: CustomAVPlayerViewController?
    private var observation: NSKeyValueObservation?
    private var videos: [VideoData]
    private var currentVideo: VideoData?
    private var isAutoPlay: Bool = false
    
    init(_ videos: [VideoData], _ id: Int, _ isAutoPlay: Bool) {
        self.currentVideo = videos.first(where: { $0.id == id })
        self.videos = videos
        self.isAutoPlay = isAutoPlay
        loadingVideoPlayer()
    }
    
    func deInitialization() {
        
    }
    
    func getPlayerViewController() -> CustomAVPlayerViewController? {
        return playerViewController
    }
    
    // MARK:- Private Methods
    
    private func loadingVideoPlayer(_ isNextPlay: Bool = false) {
        if let currentVideo = currentVideo, let url = URL(string: currentVideo.videoURL) {
            let mediaItem = AVPlayerItem(url: url)
            let titleMetadataItem = getMetadataItem(currentVideo.title, isTitle: true)
            let descriptionMetadataItem = getMetadataItem(currentVideo.description, isTitle: false)
            mediaItem.externalMetadata.append(titleMetadataItem)
            mediaItem.externalMetadata.append(descriptionMetadataItem)
            if let image = UIImage(named: currentVideo.image),
               let imageData = image.pngData() {
                let artworkMetadataItem = AVMutableMetadataItem()
                artworkMetadataItem.locale = Locale.current
                artworkMetadataItem.key = AVMetadataKey.commonKeyArtwork as NSString
                artworkMetadataItem.keySpace = AVMetadataKeySpace.common
                artworkMetadataItem.value = imageData as NSData
                // Append the metadata items to the media item
                mediaItem.externalMetadata.append(artworkMetadataItem)
            }
            
            playVideoPlayer(isNextPlay, playItem: mediaItem)
        }
        
    }
    
    private func getMetadataItem(_ text: String?, isTitle: Bool) -> AVMutableMetadataItem {
        let metadataItem = AVMutableMetadataItem()
        metadataItem.locale = Locale.current
        if isTitle {
            metadataItem.key = AVMetadataKey.commonKeyTitle as NSString
        } else {
            metadataItem.key = AVMetadataKey.commonKeyDescription as NSString
        }
        metadataItem.keySpace = AVMetadataKeySpace.common
        metadataItem.setValue(text, forKey: "value")
        return metadataItem
    }

    private func playVideoPlayer(_ isNextPlay: Bool, playItem: AVPlayerItem) {
        if isNextPlay {
          //  displayUpNextPrograms()
            player?.replaceCurrentItem(with: playItem)
            player?.play()
        } else {
            self.readyToPlay(playItem)
        }
    }
    
    private func readyToPlay(_ mediaItem: AVPlayerItem) {
        player = AVPlayer(playerItem: mediaItem)
        playerViewController = CustomAVPlayerViewController()
        playerViewController?.nextVideoPlay = { [weak self] in
            guard let self else { return }
            self.playNextEpiosde()
        }
        playerViewController?.watchCreditAction = { [weak self] in
            guard let self else { return }
            self.watchCreditAction()
        }
        playerViewController?.selectUpNextProgram = { [weak self] programId in
            guard let self else { return }
            deInitialization()
            playerViewController?.player = nil
        }
    
        playerViewController?.player = player
        
        self.observation = player?.currentItem?.observe(\.status, options: .new) { [weak self] item, _ in
            if item.status == .readyToPlay {
                self?.player?.play()
                self?.addTimeObserver()
            }
        }
    }
    
    /// Adding observer to update seeker when the video is Playing
    private func addTimeObserver() {
        guard !isObserverAdded else { return }
        player?.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: 600), queue: .main, using: { time in
            if let currentPlayerItem = self.player?.currentItem {
                let totalDuration = currentPlayerItem.duration.seconds
                
                if totalDuration > 0 {
                    let watchedThreshold = CMTimeMake(value: Int64(self.getCreditPosition(totalDuration)), timescale: 1)
                    // This method should call only once
                    guard self.isAutoPlay else { return }
                    if time >= watchedThreshold && !self.isPlayNextEpisode {
                        self.isPlayNextEpisode = true
                        if self.currentVideo?.id == self.videos.last?.id {
                            // Stop playing the video
                        } else {
                            self.playerViewController?.showEndOfEpisodeActions()
                        }
                    } else {
                        if time < watchedThreshold {
                            self.isPlayNextEpisode = false
                        }
                    }
                }
            }
        })
    
        isObserverAdded = true
    }
    
    private func getCreditPosition(_ duration: Double) -> Int {
        return Int(Double(duration) * Double(0.98))
    }
    
    private func playNextEpiosde() {
        var index = 0
        for i in 0...videos.count-1 {
            let video = videos[i]
            if(video.id == currentVideo?.id) {
                index = i + 1
                break
            }
        }
        if index < videos.count {
            currentVideo = videos[index]
            loadingVideoPlayer(true)
        }
        
    }
    
    private func watchCreditAction() {
        
    }
}
