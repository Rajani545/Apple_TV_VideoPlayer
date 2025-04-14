//
//  CustomAVPlayerViewController.swift
//  Apple_TV
//
//  Created by Rajani Karukola on 2025-03-31.
//

import Foundation
import AVKit
import SwiftUI

// A wrapper for AVPlayerViewController with added custom controls
class CustomAVPlayerViewController: AVPlayerViewController {
    var skipToTime: CMTime = CMTimeMake(value: 15, timescale: 1)
    var skipRange: CMTimeRange = CMTimeRange(start: CMTimeMake(value: 0, timescale: 1), end: CMTimeMake(value: 15, timescale: 1))
    var timeObserver: Any?
    var endRange: CMTimeRange?
    var nextVideoPlay: (() -> Void)?
    var watchCreditAction: (() -> Void)?
    var handlePlayerPaused:(() -> Void)?
    var handlePlayerPlay:(() -> Void)?
    var selectUpNextProgram: ((String) -> Void)?
    
    private lazy var skipAction = UIAction(title: "Skip Intro") { [weak self] _ in
        guard let self = self else { return }
        self.player?.seek(to: self.skipToTime)
    }
    
    private lazy var nextEpisodeAction = UIAction(title: "Next Episode", image: UIImage(named: "ic_play")) { [weak self] _ in
        guard let self = self else { return }
        self.playNextEpisode()
    }
    
    private lazy var watchCreditsAction = UIAction(title: "Watch Credits") { [weak self] _ in
        guard let self = self else { return }
        self.watchCredits()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observePlayerState()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayer.timeControlStatus) {
            if let player = object as? AVPlayer {
                switch player.timeControlStatus {
                case .paused:
                    handlePlayerPaused?()
                case .playing:
                    handlePlayerPlay?()
                case .waitingToPlayAtSpecifiedRate:
                    debugPrint("Player is waiting to play at specified rate")
                @unknown default:
                    break
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove the observer for timeControlStatus when the view is about to disappear
        if let player = self.player {
            // Check if the player is still observing before trying to remove
            if player.observationInfo != nil {
                player.removeObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus))
            }
        }
        // Remove the time observer
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
    }
    
    func addUpdateNextView() {
        let view = UpNextPrograms { programId in
            self.selectUpNextProgram?(programId)
        }
        let hostingController = UIHostingController(rootView: view)
        hostingController.title = "Up Next"
        hostingController.preferredContentSize = CGSize(width: 300, height: 200)
        self.customInfoViewControllers = [hostingController]
    }
        
    func skipButton(time: CMTime) {
        let actions = self.skipRange.containsTime(time) ? [self.skipAction] : []
        self.contextualActions = actions
    }
    
    func observePlayerState() {
        self.player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus), options: [.new], context: nil)
    }
    
    func showEndOfEpisodeActions() {
        self.playbackControlsIncludeTransportBar = false
        self.contextualActions = [watchCreditsAction, nextEpisodeAction]
    }
    
    func playNextEpisode() {
        self.contextualActions = []
        self.playbackControlsIncludeTransportBar = true
        nextVideoPlay?()
    }
    
    func watchCredits() {
        self.contextualActions = []
        self.playbackControlsIncludeTransportBar = true
        watchCreditAction?()
    }
}


