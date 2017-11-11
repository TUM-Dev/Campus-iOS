//
//  CardTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit


protocol SingleDataElementPresentable {
    func setElement(_ element: DataElement)
}

protocol MultipleDataElementsPresentable {
    
    weak var collectionView: UICollectionView! { get set }
    weak var collectionViewHeight: NSLayoutConstraint! { get set }
    func setDataSource<T>(dataSource: T, id: Int) where T: UICollectionViewDelegate & UICollectionViewDataSource
}

extension MultipleDataElementsPresentable {
    
    func setDataSource<T>(dataSource: T, id: Int) where T : UICollectionViewDataSource & UICollectionViewDelegate {
        collectionView.tag = id
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.reloadData()
    }
}


@IBDesignable class CardTableViewCell: UITableViewCell {
	
	@IBInspectable var topGradientColor: UIColor = UIColor.white
	@IBInspectable var bottomGradientColor: UIColor = UIColor.black
    
    let gradientLayer = CAGradientLayer()
    
    func configureBackgroundGradient() {
        gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        gradientLayer.opacity = 0.05
        self.contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureBackgroundGradient()
    }
	
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureBackgroundGradient()
    }
}
