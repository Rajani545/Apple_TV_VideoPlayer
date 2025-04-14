//
//  VideoPlayerView.swift
//  Apple_TV
//
//  Created by Rajani Karukola on 2025-03-31.
//

import Foundation
import SwiftUI

struct VideoPlayerView: View {
    @StateObject private var vm: VideoPlayerViewModel
    
    init(_ videos: [VideoData], _ index: Int, _ isAutoPlay: Bool) {
        _vm = StateObject(wrappedValue: VideoPlayerViewModel(videos, index, isAutoPlay))
    }

    
    var body: some View {
        NavigationStack {
            VStack {
                if let playerViewController = vm.getPlayerViewController() {
                    PlayerViewRepresentable(playerViewController: playerViewController)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
            }
        }
        .onDisappear() {
            vm.deInitialization()
        }
    }
}
