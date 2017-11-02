//
//  RoomFinderViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import AYSlidingPickerView

class RoomFinderViewController: UIViewController, DetailView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var delegate: DetailViewDelegate?
    var room: DataElement?
    
    var barItem: UIBarButtonItem?
    var maps = [Map]()
    var currentMap: Map? {
        didSet {
            refreshImage()
        }
    }
    
    var pickerView = AYSlidingPickerView()
    
    var binding: ImageViewBinding?
    
    func refreshImage() {
        binding = currentMap?.image.bind(to: imageView, default: nil)
        title = currentMap?.description
        scrollView.zoomScale = 1.0
        scrollView.contentSize = imageView.bounds.size
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
    }
    
}

extension RoomFinderViewController {
    
    func fetch(id: String) {
        delegate?.dataManager()?.roomMapsManager.search(query: id).onSuccess(in: .main) { maps in
            self.maps = maps.sorted { $0.scale < $1.scale }
            if !maps.isEmpty {
                self.currentMap = self.maps.first
            }
            self.setUpPickerView()
        }
    }
    
}

extension RoomFinderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        scrollView.delegate = self
        if let roomUnwrapped = room as? Room {
            fetch(id: roomUnwrapped.number)
        } else if let roomUnwrapped = room as? StudyRoom {
            fetch(id: roomUnwrapped.architectNumber)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pickerView.removeFromSuperview()
    }
    
}

extension RoomFinderViewController {
    
    func showMaps(_ send: AnyObject?) {
        pickerView.show()
        barItem?.action = #selector(RoomFinderViewController.hideMaps(_:))
        barItem?.image = UIImage(named: "collapse")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func hideMaps(_ send: AnyObject?) {
        pickerView.dismiss()
        barItem?.action = #selector(RoomFinderViewController.showMaps(_:))
        barItem?.image = UIImage(named: "expand")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
        pickerView.didDismissHandler = { self.hideMaps(nil) }
        
        barItem = UIBarButtonItem(image: UIImage(named: "expand"),
                                  style: UIBarButtonItemStyle.plain,
                                  target: self,
                                  action:  #selector(RoomFinderViewController.showMaps(_:)))
        navigationItem.rightBarButtonItem = barItem
    }
    
}
