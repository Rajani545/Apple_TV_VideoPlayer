//
//  PlayerViewRepresentable.swift
//  Apple_TV
//
//  Created by Streaming on 2025-03-31.
//

import Foundation
import SwiftUI

struct PlayerViewRepresentable: UIViewRepresentable {
    let playerViewController: CustomAVPlayerViewController

    func makeUIView(context: Context) -> UIView {
        return playerViewController.view
    }

    func updateUIView(_ uiView: UIView, context: Context) { }
}
