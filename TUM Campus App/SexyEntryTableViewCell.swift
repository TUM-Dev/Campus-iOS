//
//  SexyEntryTableViewCell.swift
//  TUM Campus App
//

import UIKit

class SexyEntryTableViewCell: UITableViewCell {

    var entry: SexyEntry? {
        didSet {
            textLabel?.text = entry?.descriptionText
            guard let name = entry?.name else {
                detailTextLabel?.text = nil
                return
            }
            detailTextLabel?.text = "\(name).tum.sexy"
        }
    }

}
