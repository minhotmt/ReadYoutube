//
//  SecondVC.swift
//  ReadYoutube
//
//  Created by MinhNV-GD on 2/5/20.
//  Copyright © 2020 MinhNV-GD. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SecondVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getApi()
    }
    
    func getApi() {
        Alamofire.request("http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topfreeapplications/limit=100/json").responseJSON {
            (response) in
            guard let value = response.result.value else { return }
            let responseValue = JSON(value)
            if let entry = responseValue["feed"]["entry"].array {
                print(entry)
            }
        }
    }
    
}
