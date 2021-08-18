//
//  VideoModel.swift
//  ReadYoutube
//
//  Created by Minh Nguyen on 8/18/21.
//  Copyright © 2021 MinhNV-GD. All rights reserved.
//

import Foundation

struct VideosModel: Decodable {
    let items: [ItemVideo]
}

struct ItemVideo: Decodable {
    let id: VideoID
    let snippet: InfoVideo
}

struct VideoID: Decodable {
    let videoId: String
}

struct InfoVideo: Decodable {
    let thumbnails: ImageThumnail
    let title: String
    let publishedAt: String
    let channelTitle: String
}

struct ImageThumnail: Decodable {
    let high: ImageHigh
}

struct ImageHigh: Decodable {
    let url: String
}
