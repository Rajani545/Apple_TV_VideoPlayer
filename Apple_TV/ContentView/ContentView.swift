//
//  ContentView.swift
//  Apple_TV
//
//  Created by Rajani Karukola on 2025-03-31.
//

import SwiftUI

struct ContentView: View {
    @FocusState var focusVideo: VideoData?
    @StateObject var vm = ContentViewModel()
    @State private var isAutoPlay = true

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Text("Video Player")
                        .font(.title)
                    Spacer()
                    Toggle("Auto Play", isOn: $isAutoPlay)
                        .frame(width: 350)
                    
                }
                
                
                Spacer(minLength: 30) // Added for extra space
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(vm.videos, id: \.id) { video in
                            Button {
                                vm.isVideoPlayer = true
                            } label: {
                                HStack {
                                    Image(video.image)
                                        .resizable()
                                        .frame(width: 200, height: 300)
                                    VStack(alignment: .leading, spacing: 20) {
                                        Text(video.title)
                                            .font(.title)
                                            .multilineTextAlignment(.leading)
                                        Text(video.description)
                                            .font(.callout)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "play.fill")
                                            .font(.caption)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .focused($focusVideo, equals: video)
                        }
                    }
                    .padding(.horizontal, 100)
                }
                
            }
            .navigationDestination(isPresented: $vm.isVideoPlayer) {
                VideoPlayerView(vm.videos, focusVideo?.id ?? 0, isAutoPlay)
            }
        }
    }
}

#Preview {
    ContentView()
}
