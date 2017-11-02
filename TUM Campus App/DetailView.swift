//
//  DetailView.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
protocol DetailView {
    weak var delegate: DetailViewDelegate? { get set }
}
