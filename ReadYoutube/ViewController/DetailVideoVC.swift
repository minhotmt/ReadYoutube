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
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var labelSpeed: UILabel!
    
    
    var idVideo: String = ""
    var speedRate: Float = 1.2

    override func viewDidLoad() {
        super.viewDidLoad()
        viewPlayer.load(withVideoId: idVideo)
        viewPlayer.delegate = self
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        labelSpeed.text = "\(Double(round(10*sliderView.value)/10))"
        speedRate = sliderView.value
    }
}

extension DetailVideoVC: YTPlayerViewDelegate {
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .playing {
            viewPlayer.setPlaybackRate(speedRate)
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        viewPlayer.playVideo()
    }
}
