//
//  CafeteriaCollectionViewCell.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import MapKit

class CafeteriaCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func configure(_ cafeteria: Cafeteria) {
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(cafeteria)
        mapView.showAnnotations([cafeteria], animated: false)
        mapView.isUserInteractionEnabled = false
        nameLabel.text = cafeteria.name ?? ""
        addressLabel.text = "missing address \(cafeteria.menu?.count) / \(cafeteria.sides?.count)"
    }
}
