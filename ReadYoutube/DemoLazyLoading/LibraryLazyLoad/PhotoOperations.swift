//
//  PhotoRecordState.swift
//  ProjectSummury
//
//  Created by MinhNV-GD on 2/12/20.
//  Copyright © 2020 TruongTV-GD. All rights reserved.
//

import Foundation
import UIKit

// This enum contains all the possible states a photo record can be in
enum PhotoRecordState {
    case new, downloaded, filtered, failed
}

class PhotoRecord {
    let name: String
    let url: URL
    var state = PhotoRecordState.new
    var image = UIImage(named: "Placeholder")
    
    init(name:String, url:URL) {
        self.name = name
        self.url = url
    }
}

// PendingOperations: This class contains two dictionaries to keep track of active and pending download and filter operations for each row in the table, and an operation queues for each type of operation.
class PendingOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var filtrationsInProgress: [IndexPath: Operation] = [:]
    lazy var filtrationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}


class ImageDownloader: Operation {
    //1
    let photoRecord: PhotoRecord
    
    //2
    init(_ photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    //3
    override func main() {
        //4
        if isCancelled {
            return
        }
        
        //5
        guard let imageData = try? Data(contentsOf: photoRecord.url) else { return }
        
        //6
        if isCancelled {
            return
        }
        
        //7
        if !imageData.isEmpty {
            photoRecord.image = UIImage(data:imageData)
            photoRecord.state = .downloaded
        } else {
            photoRecord.state = .failed
            photoRecord.image = UIImage(named: "Failed")
        }
    }
}

class ImageFiltration: Operation {
    let photoRecord: PhotoRecord
    
    init(_ photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main () {
        if isCancelled {
            return
        }
        
        guard self.photoRecord.state == .downloaded else {
            return
        }
        
        if let image = photoRecord.image,
            let filteredImage = applySepiaFilter(image) {
            photoRecord.image = filteredImage
            photoRecord.state = .filtered
        }
    }
    
    func applySepiaFilter(_ image: UIImage) -> UIImage? {
        guard let data = image.pngData() else { return nil }
        let inputImage = CIImage(data: data)
        
        if isCancelled {
            return nil
        }
        
        let context = CIContext(options: nil)
        
        guard let filter = CIFilter(name: "CISepiaTone") else { return nil }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: "inputIntensity")
        
        if isCancelled {
            return nil
        }
        
        guard
            let outputImage = filter.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent)
            else {
                return nil
        }
        
        return UIImage(cgImage: outImage)
    }
}
