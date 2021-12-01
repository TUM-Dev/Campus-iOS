//
//  MapViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 25.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Kingfisher

final class MapViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewTrailingConstraint: NSLayoutConstraint!

    var room: Room?
    var map: RoomMap?

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        if let room = room,
            let map = map,
            let mapURL = TUMCabeAPI.mapImage(room: room.id, id: map.id).urlRequest?.url {
            imageView.kf.setImage(with: mapURL, options: [.transition(.fade(0.2))])
        }
        scrollView.delegate = self
        scrollView.backgroundColor = .systemBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMinZoomScaleForSize(view.bounds.size)
        updateConstraintsForSize(view.bounds.size)
    }

    func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / (imageView.image?.size.width ?? 1)
        let heightScale = size.height / (imageView.image?.size.height ?? 1)
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = minScale * 6
        scrollView.zoomScale = minScale
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }


    func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset

        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset

        view.layoutIfNeeded()
    }

    @IBAction private func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
