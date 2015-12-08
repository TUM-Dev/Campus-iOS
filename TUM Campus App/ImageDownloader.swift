//
//  ImageDownloader.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import UIKit
class ImageDownloader {
    
    init(url: String) {
        getImage(url)
    }
    
    init() {}
    
    var image: UIImage?
 
    var subscribersToImage = [ImageDownloadSubscriber]()
    
    func notifySubscribers() {
        for s in self.subscribersToImage {
            s.updateImageView()
        }
    }
    
    func subscribeToImage(subscriber: ImageDownloadSubscriber) {
        subscribersToImage.append(subscriber)
    }
    
    func getImage(urlString: String) {
        if let url = NSURL(string: urlString) {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)) {
                if let data = NSData(contentsOfURL: url), imageFromData = UIImage(data: data) {
                    self.image = imageFromData
                    dispatch_async(dispatch_get_main_queue()) {
                        self.notifySubscribers()
                    }
                }
            }
        }
    }
    
}