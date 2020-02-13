//
//  TimeLineCell.swift
//  ReadYoutube
//
//  Created by MinhNV-GD on 2/12/20.
//  Copyright © 2020 MinhNV-GD. All rights reserved.
//

import Foundation
import UIKit

class TimeLineCell: UITableViewCell {
    
    static let identifier = "TimeLineCell"
    
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imgTimeLine: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
}

