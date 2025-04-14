//
//  ContentViewModel.swift
//  Apple_TV
//
//  Created by Streaming on 2025-03-31.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    
    @Published var isVideoPlayer: Bool = false
    var videos: [VideoData] = [
        VideoData(id: 1,
                  image: "bigBuck",
                  videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                  title: "Big Buck Bunny",
                  description: "Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain't no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.\n\nLicensed under the Creative Commons Attribution license\nhttp://www.bigbuckbunny.org"),
        VideoData(id: 2,
                   image: "elephants_poster",
                   videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
                   title: "Elephant Dream",
                   description: "The first Blender Open Movie from 2006"),
        VideoData(id: 3,
                   image: "sintel_poster",
                   videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
                   title: "Sintel",
                   description: "Sintel is an independently produced short film, initiated by the Blender Foundation as a means to further improve and validate the free/open source 3D creation suite Blender. With initial funding provided by 1000s of donations via the internet community, it has again proven to be a viable development model for both open 3D technology as for independent animation film."),
        VideoData(id: 4,
                   image: "tearOfSteel",
                   videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
                   title: "Tears of Steel",
                   description: "Tears of Steel was realized with crowd-funding by users of the open source 3D creation tool Blender. Target was to improve and test a complete open and free pipeline for visual effects in film - and to make a compelling sci-fi film in Amsterdam, the Netherlands.")
    ]
}
