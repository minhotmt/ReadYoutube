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
    
    @IBOutlet weak var tableView: UITableView!
    
    let domainApi = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=e6ad45422e7fef7ae91b9e3172f4a8dd&format=json&nojsoncallback=1&text=cats&extras=url_o"
    
    var listEvent: [Event] = []
    var listPhoto: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        getApi()
        getApiCat()
    }
    
    func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ImageCell.identifier, bundle: nil), forCellReuseIdentifier: ImageCell.identifier)
    }
    
    func getApi() {
        Alamofire.request("http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topfreeapplications/limit=100/json").responseJSON {
            (response) in
            guard let value = response.result.value else { return }
            let responseValue = JSON(value)
            if let entry = responseValue["feed"]["entry"].array {
                for index in 0...99 {
                    let event = Event(json: entry[index])
                    self.listEvent.append(event)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func getApiCat() {
        Alamofire.request(domainApi).responseJSON { (response) in
            guard let value = response.result.value else { return }
            let responseValue = JSON(value)
            if let photos = responseValue["photos"]["photo"].array {
                for index in 0...(photos.count - 1) {
                    let photo = Photo(json: photos[index])
                    self.listPhoto.append(photo)
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension SecondVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPhoto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        cell.img.downloadImage(from: listPhoto[indexPath.row].url!)
        return cell
    }
    
}

class Event {
    
    var name: String?
    var imageUrl: URL?
    
    init(name: String, imageUrl: URL) {
        self.name = name
        self.imageUrl = imageUrl
    }
    
    init(json: JSON) {
        if let name = json["im:name"]["label"].string {
            self.name = name
        }
        if let imageUrl = json["im:image"][2]["label"].string {
            self.imageUrl = URL(string: imageUrl)!
        }
    }
}

class Photo {
    var url: URL?
    
    init(url: URL) {
        self.url = url
    }
    
    init(json: JSON) {
        if let url = json["url_o"].string {
            self.url = URL(string: url)!
        } else {
            self.url = URL(string: "https://live.staticflickr.com/65535/49528442063_ae7fd44aa5_o.jpg")!
        }
    }
}

extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
}
