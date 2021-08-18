//
//  YoutubeVC.swift
//  ReadYoutube
//
//  Created by Minh Nguyen on 5/21/21.
//  Copyright © 2021 MinhNV-GD. All rights reserved.
//

import UIKit
import Alamofire

class YoutubeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarItem: UISearchBar!
    
    var videos: [ItemVideo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(search: "Thoi su hom nay")
        setupView()
    }
    
    private func setupView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        searchBarItem.delegate = self
    }
    
    private func getData(search: String){
        
        let apiString = "https://www.googleapis.com/youtube/v3/search"
        let parameters = [
            "q": "\(search)",
            "key": "AIzaSyAglwpoM1HZ8Gq1oLGxfKLZIaYykE_apko",
            "part": "snippet",
            "maxResults": "20",
            "type": "video"
        ]
        
        Alamofire.request(apiString, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let json):
                print(json)
                let result = response.data
                do {
                    let ss = try JSONDecoder().decode(VideosModel.self, from: result!)
                    self.videos = ss.items
                    self.tableView.reloadData()
                } catch {
                    print("Error")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension YoutubeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.setupData(data: videos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailVideoVC()
        vc.idVideo = videos[indexPath.row].id.videoId
        let navViewController = self.tabBarController?.selectedViewController as? UINavigationController
        navViewController?.pushViewController(vc, animated: true)
    }
    
}

extension YoutubeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getData(search: searchBar.text ?? "")
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
