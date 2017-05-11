//
//  RoomFinderViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import AYSlidingPickerView

class RoomFinderViewController: UIViewController, ImageDownloadSubscriber, DetailView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var delegate: DetailViewDelegate?
    var room: DataElement?
    
    var barItem: UIBarButtonItem?
    var maps = [Map]()
    var currentMap: Map? {
        didSet {
            refreshImage()
        }
    }
    
    var pickerView = AYSlidingPickerView()
    
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
    
}

extension RoomFinderViewController: TumDataReceiver {
    
    func receiveData(_ data: [DataElement]) {
        maps.removeAll()
        for item in data {
            if let map = item as? Map {
                maps.append(map)
            }
        }
        maps = maps.sorted {$0.scale < $1.scale} // Sort maps by their scale, so the smallest one is displayed as default
        if !maps.isEmpty {
            currentMap = maps.first
        }
        setUpPickerView()
    }
    
}

extension RoomFinderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        scrollView.delegate = self
        if let roomUnwrapped = room as? Room {
            delegate?.dataManager().getMapsForRoom(self, roomID: roomUnwrapped.number)
        } else if let roomUnwrapped = room as? StudyRoom {
            delegate?.dataManager().getMapsForRoom(self, roomID: roomUnwrapped.architectNumber)
        }
    }
    
}

extension RoomFinderViewController {
    
    func showMaps(_ send: AnyObject?) {
        pickerView.show()
        barItem?.action = #selector(RoomFinderViewController.hideMaps(_:))
        barItem?.image = UIImage(named: "collapse")
        navigationController?.view.isUserInteractionEnabled = false
    }
    
    func hideMaps(_ send: AnyObject?) {
        pickerView.dismiss()
        barItem?.action = #selector(RoomFinderViewController.showMaps(_:))
        barItem?.image = UIImage(named: "expand")
        navigationController?.view.isUserInteractionEnabled = true
    }
    
}

extension RoomFinderViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

extension RoomFinderViewController {
    
    func setUpPickerView() {
        var items = [AnyObject]()
        for item in maps {
            let item = AYSlidingPickerViewItem(title: item.description) { (did) in
                if did {
                    self.currentMap = item
                    self.barItem?.action = #selector(RoomFinderViewController.showMaps(_:))
                    self.barItem?.image = UIImage(named: "expand")
                }
            }
            items.append(item!)
        }
        pickerView = AYSlidingPickerView.sharedInstance()
        pickerView.mainView = navigationController?.view ?? view
        pickerView.items = items
        pickerView.selectedIndex = 0
        pickerView.closeOnSelection = true
        barItem = UIBarButtonItem(image: UIImage(named: "expand"), style: UIBarButtonItemStyle.plain, target: self, action:  #selector(RoomFinderViewController.showMaps(_:)))
        navigationItem.rightBarButtonItem = barItem
    }
    
}
