//
//  HomeVC.swift
//  ReadYoutube
//
//  Created by MinhNV-GD on 2/5/20.
//  Copyright © 2020 MinhNV-GD. All rights reserved.
//

import UIKit
import CoreImage


class HomeVC: UIViewController {
    
    let dataSourceURL = URL(string:"http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist")!
    
    //lazy loading variable
    var photos: [PhotoRecord] = []
    let pendingOperations = PendingOperations()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchPhotoDetails()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TimeLineCell.identifier, bundle: nil), forCellReuseIdentifier: TimeLineCell.identifier)
    }
    
}

extension HomeVC {
    
    func fetchPhotoDetails() {
        let request = URLRequest(url: dataSourceURL)
        
        // 1
        let task = URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            
            // 2
            let alertController = UIAlertController(title: "Oops!",
                                                    message: "There was an error fetching photo details.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            if let data = data {
                do {
                    // 3
                    let datasourceDictionary =
                        try PropertyListSerialization.propertyList(from: data,
                                                                   options: [],
                                                                   format: nil) as! [String: String]
                    
                    // 4
                    for (name, value) in datasourceDictionary {
                        let url = URL(string: value)
                        if let url = url {
                            let photo = PhotoRecord(name: name, url: url)
                            self.photos.append(photo)
                        }
                    }
                    
                    // 5
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    // 6
                } catch {
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            // 6
            if error != nil {
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        // 7
        task.resume()
    }
    
    func startOperations(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        switch (photoRecord.state) {
        case .new:
            startDownload(for: photoRecord, at: indexPath)
        case .downloaded:
            startFiltration(for: photoRecord, at: indexPath)
        default:
            NSLog("do nothing")
        }
    }
    
    func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        //1
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        //2
        let downloader = ImageDownloader(photoRecord)
        
        //3
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                UIView.performWithoutAnimation {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
        
        //4
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        //5
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func startFiltration(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        guard pendingOperations.filtrationsInProgress[indexPath] == nil else {
            return
        }
        
        let filterer = ImageFiltration(photoRecord)
        filterer.completionBlock = {
            if filterer.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        pendingOperations.filtrationsInProgress[indexPath] = filterer
        pendingOperations.filtrationQueue.addOperation(filterer)
    }
    
    func suspendAllOperations() {
        pendingOperations.downloadQueue.isSuspended = true
        pendingOperations.filtrationQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
        pendingOperations.filtrationQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells() {
        //1
        if let pathsArray = tableView.indexPathsForVisibleRows {
            //2
            var allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            allPendingOperations.formUnion(pendingOperations.filtrationsInProgress.keys)
            
            //3
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            
            //4
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            // 5
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                if let pendingFiltration = pendingOperations.filtrationsInProgress[indexPath] {
                    pendingFiltration.cancel()
                }
                pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
            }
            
            // 6
            for indexPath in toBeStarted {
                let recordToProcess = photos[indexPath.row]
                startOperations(for: recordToProcess, at: indexPath)
            }
        }
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeLineCell.identifier, for: indexPath) as! TimeLineCell
        
        //1
        let photoDetails = photos[indexPath.row]
        
        //2
        cell.imgTimeLine.image = photoDetails.image
        
        //3
        switch (photoDetails.state) {
        case .filtered:
            print("stop loading")
            cell.viewIndicator.isHidden = true
        case .failed:
            print("stop loading")
            cell.viewIndicator.isHidden = true
        case .new, .downloaded:
            print("begin loading")
            cell.viewIndicator.isHidden = false
            cell.viewIndicator.startAnimating()
            if !tableView.isDragging && !tableView.isDecelerating {
                startOperations(for: photoDetails, at: indexPath)
            }
        }
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //1
        print("--->Begin dragging")
        suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 2
        print("--->Did end dragging")
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 3
        print("--->Did end Decelerating")
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    
}
