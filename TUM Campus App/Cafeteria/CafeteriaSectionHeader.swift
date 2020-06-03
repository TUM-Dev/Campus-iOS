//
//  CafeteriaSectionHeader.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 7.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import MapKit

final class CafeteriaSectionHeader: UICollectionReusableView {
    @IBOutlet weak var mapView: MKMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupMapView()
    }

    private func setupMapView() {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        mapView.pointOfInterestFilter = .includingAll
    }
}
