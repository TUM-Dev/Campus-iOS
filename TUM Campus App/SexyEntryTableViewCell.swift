//
//  SexyEntryTableViewCell.swift
//  TUM Campus App
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
