//
//  SexyEntryTableViewCell.swift
//  TUM Campus App
//

import UIKit

class SexyEntryTableViewCell: CardTableViewCell {
    
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
    
    override func setElement(_ element: DataElement) {
        entry = element as? SexyEntry
    }

}
