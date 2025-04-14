//
//  UpNextPrograms.swift
//  Apple_TV
//
//  Created by Rajani Karukola on 2025-03-31.
//

import Foundation
import SwiftUI

struct UpNextPrograms: View {
    @FocusState private var focusedItem: VideoData?
    let selectProgram: (String) -> Void
    @State private var isProgram = false
    
    var body: some View {
        VStack {
            Text("Display the videos here")
        }
    }
}

