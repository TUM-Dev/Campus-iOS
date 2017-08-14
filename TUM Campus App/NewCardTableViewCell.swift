//
//  NewCardTableViewCell.swift
//  
//
//  Created by Tim Gymnich on 13.08.17.
//
//

import UIKit

class NewCardTableViewCell: UITableViewCell {
	
	var title: String
	var titleColor: UIColor
	var gradientLayer = CAGradientLayer()
	
	@IBOutlet weak var titleLabel: UILabel!
	
	init(style: UITableViewCellStyle, reuseIdentifier: String?, title: String, titleColor: UIColor) {
		self.title = title
		self.titleColor = titleColor
		titleLabel.text = title
		titleLabel.textColor = titleColor
		let color1 = UIColor.white.cgColor
		let color2 = UIColor.black.cgColor
		self.gradientLayer.colors = [color1, color2]
		self.gradientLayer.locations = [0.75, 1.0]
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.backgroundView?.layer.insertSublayer(gradientLayer, at: 0)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	func setElement(_ element: DataElement) {
		
	}

}
