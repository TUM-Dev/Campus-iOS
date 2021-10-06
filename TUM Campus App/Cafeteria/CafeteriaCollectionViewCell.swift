//
//  CafeteriaCollectionViewCell.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//


import UIKit
import MapKit

final class CafeteriaCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet weak var openMenuBtn: OpenMenuBtnClass!

    private static let distanceFormatter: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter
    }()
    
    func configure(cafeteria: Cafeteria, currentLocation: CLLocation?) {
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.borderWidth = 2
        
        self.layer.cornerRadius = 15
        
        nameLabel.text = cafeteria.name
        addressLabel.text = cafeteria.location.address
        if let currentLocation = currentLocation {
            let distance = cafeteria.coordinate.location.distance(from: currentLocation)
            distanceLabel.text = CafeteriaCollectionViewCell.distanceFormatter.string(fromDistance: distance)
            distanceLabel.textAlignment = .right
        } else {
            distanceLabel.text = ""
        }
        
        //MARK: - Constraints
                
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 23).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 17).isActive = true
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 17).isActive = true
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        
        openMenuBtn.translatesAutoresizingMaskIntoConstraints = false
        openMenuBtn.setTitle("", for: .normal)
        openMenuBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 13).isActive = true
        openMenuBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -13).isActive = true
    }
}

class OpenMenuBtnClass: UIButton {
    var caf: Cafeteria?
}
