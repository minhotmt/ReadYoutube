//
//  VideoCell.swift
//  ReadYoutube
//
//  Created by Minh Nguyen on 8/18/21.
//  Copyright © 2021 MinhNV-GD. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCell: UITableViewCell {

    @IBOutlet weak var imgThumnails: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblChanel: UILabel!
    
    func setupData(data: ItemVideo){
        lblTitle.text = data.snippet.title
        lblChanel.text = data.snippet.channelTitle
        imgThumnails.setKfImg(urlString: data.snippet.thumbnails.high.url)
    }
    
}

extension UIImageView {
    func setKfImg(urlString: String){
        let url = URL(string: urlString)
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: UIImage(),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
        }
    }
}

