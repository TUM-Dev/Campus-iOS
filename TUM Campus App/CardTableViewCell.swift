//
//  CardTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import FoldingCell

protocol TableViewCellDelegate {

    func cardDeleted(card: FoldingCell)
}

class CardTableViewCell: FoldingCell {
    
    var originalCenter = CGPoint()
    var deleteLeftOnDragRelease = false
    var deleteRightOnDragRelease = false
    var delegate: TableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(swipeGesture(sender:)))
        swipeGestureRecognizer.delegate = self
        addGestureRecognizer(swipeGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(swipeGesture(sender:)))
        swipeGestureRecognizer.delegate = self
        addGestureRecognizer(swipeGestureRecognizer)
    }
    
    func swipeGesture(sender: UIPanGestureRecognizer) {
        
        let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
        
        switch sender.state {
            
        case .began:
            originalCenter = center
        
        case .changed:
            let translation = sender.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            deleteLeftOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            deleteRightOnDragRelease = frame.origin.x > frame.size.width / 2.0
        
        case .ended:
            if deleteLeftOnDragRelease {
                let newFrame = CGRect(x: -600, y: originalFrame.minY , width: originalFrame.width, height: originalFrame.height)
                UIView.animate(withDuration: 0.5, animations: {
                    self.frame = newFrame
                }, completion: { (finished) in
                    self.delegate?.cardDeleted(card: self)
                })
            } else if deleteRightOnDragRelease {
                let newFrame = CGRect(x: 600, y: originalFrame.minY , width: originalFrame.width, height: originalFrame.height)
                UIView.animate(withDuration: 0.5, animations: {
                    self.frame = newFrame
                }, completion: { (finished) in
                    self.delegate?.cardDeleted(card: self)
                })
            } else {
                UIView.animate(withDuration: 0.5) { self.frame = originalFrame }
            }
            
        default:
                UIView.animate(withDuration: 0.5) { self.frame = originalFrame }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    func setElement(_ element: DataElement) {
        
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        foregroundView.layer.cornerRadius = 8
        foregroundView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
    }
    
    func isFoldingCell() -> Bool {
        return false
    }
    
    func segueIdentifier() -> String? {
        return nil
    }
}


class TableViewCell: UITableViewCell {
    
    func setElement(_ element: DataElement) {

    }
    
}

