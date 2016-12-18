//
//  PlanDetailsViewController.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 16.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class PlanDetailsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var imageUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: imageUrl)
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 5.0
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

}
