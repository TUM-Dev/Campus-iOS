//
//  AccessPointPopup.swift
//  HeatmapUIKit
//
//  Created by Kamber Vogli on 08.05.22.
//

import UIKit

class PopupTextView: UIView {
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor(red: 34 / 255, green: 34 / 255, blue: 34 / 255, alpha: 1)
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        backgroundColor = .white
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35)
        ])
    }

    func setText(_ text: String) {
        textLabel.text = text
    }
}
