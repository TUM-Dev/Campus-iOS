//
//  UITextViewNoStartInset.swift
//  Campus
//
//  Created by Till on 12.06.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class UITextViewNoStartInset: UITextView {

    override func layoutSubviews() {
        super.layoutSubviews()
        removeStartInset()
    }
    
    private func removeStartInset() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }

}
