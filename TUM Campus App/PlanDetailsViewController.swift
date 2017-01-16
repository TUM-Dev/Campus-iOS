//
//  PlanDetailsViewController.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 16.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

enum PlanType {
    case image
    case pdf
}


class PlanDetailsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!
    var webView: UIWebView!
    var planFileUrl: String!
    var planType: PlanType!
    
    // display image or pdf, depending on the file type
    override func viewDidLoad() {
        super.viewDidLoad()

        switch planType! {
        case .image:
            imageView = UIImageView()
            imageView.frame = self.view.frame
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: planFileUrl)

            self.scrollView.minimumZoomScale = 1.0
            self.scrollView.maximumZoomScale = 5.0
            scrollView.addSubview(imageView)
        case .pdf:
            webView = UIWebView()
            webView.scalesPageToFit = true
            webView.frame = self.view.frame
            
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let documentUrl = paths?.appendingPathComponent("plans/"+planFileUrl)
            webView.loadRequest(NSURLRequest(url: documentUrl!) as URLRequest)
            
            scrollView.addSubview(webView)
        }
    }
    
    // allow image zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

}
