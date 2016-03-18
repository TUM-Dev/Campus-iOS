//
//  RoomFinderViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import AYSlidingPickerView

class RoomFinderViewController: UIViewController, TumDataReceiver, ImageDownloadSubscriber, UIScrollViewDelegate {
    
    var delegate: DetailViewDelegate?
    
    var room: DataElement?
    
    var currentMap: Map? {
        didSet {
            refreshImage()
        }
    }
    
    func updateImageView() {
        refreshImage()
    }
    
    func refreshImage() {
        if let image = currentMap?.image {
            title = currentMap?.description
            imageView.image = image
            scrollView.zoomScale = 1.0
            scrollView.contentSize = imageView.bounds.size
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 5.0
        } else {
            currentMap?.subscribeToImage(self)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    var maps = [Map]()
    
    var pickerView = AYSlidingPickerView()
    
    var barItem: UIBarButtonItem?
    
    func showMaps(send: AnyObject?) {
        pickerView.show()
        barItem?.action = Selector("hideMaps:")
        barItem?.image = UIImage(named: "collapse")
    }
    
    func hideMaps(send: AnyObject?) {
        pickerView.dismiss()
        barItem?.action = Selector("showMaps:")
        barItem?.image = UIImage(named: "expand")
    }
    
    func setUpPickerView() {
        var items = [AnyObject]()
        for item in maps {
            let item = AYSlidingPickerViewItem(title: item.description) { (did) in
                if did {
                    self.currentMap = item
                    self.barItem?.action = Selector("showMaps:")
                    self.barItem?.image = UIImage(named: "expand")
                }
            }
            items.append(item)
        }
        pickerView = AYSlidingPickerView.sharedInstance()
        pickerView.mainView = view
        pickerView.items = items
        pickerView.selectedIndex = 0
        pickerView.closeOnSelection = true
        barItem = UIBarButtonItem(image: UIImage(named: "expand"), style: UIBarButtonItemStyle.Plain, target: self, action:  Selector("showMaps:"))
        navigationItem.rightBarButtonItem = barItem
    }
    
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        scrollView.delegate = self
        if let roomUnwrapped = room as? Room {
            delegate?.dataManager().getMapsForRoom(self, roomID: roomUnwrapped.number)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func receiveData(data: [DataElement]) {
        maps.removeAll()
        for item in data {
            if let cafeteria = item as? Map {
                maps.append(cafeteria)
            }
        }
        if !maps.isEmpty {
            currentMap = maps[0]
        }
        setUpPickerView()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
