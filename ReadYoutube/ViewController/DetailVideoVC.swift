//
//  DetailVideoVC.swift
//  ReadYoutube
//
//  Created by Minh Nguyen on 8/18/21.
//  Copyright © 2021 MinhNV-GD. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import AVKit

class DetailVideoVC: UIViewController {

    @IBOutlet weak var viewPlayer: YTPlayerView!
    @IBOutlet weak var v2: UIView!

    var idVideo: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        viewPlayer.load(withVideoId: idVideo)
        viewPlayer.delegate = self
    }
}

extension DetailVideoVC: YTPlayerViewDelegate {
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .playing {
            viewPlayer.setPlaybackRate(1.3)
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        viewPlayer.playVideo()
    }
}
