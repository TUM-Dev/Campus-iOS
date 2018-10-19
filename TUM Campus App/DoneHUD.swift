//
//  DoneHUD.swift
//  DoneAnimation
//
//  Created by Ryuta Kibe on 2015/08/23.
//  Copyright (c) 2015 blk. All rights reserved.
//

import UIKit

open class DoneHUD: NSObject {
    fileprivate static let sharedObject = DoneHUD()
    let doneView = DoneView()

    public static func showInView(_ view: UIView) {
        DoneHUD.sharedObject.showInView(view, message: nil)
    }
    
    public static func showInView(_ view: UIView, message: String?) {
        DoneHUD.sharedObject.showInView(view, message: message)
    }
    
    fileprivate func showInView(_ view: UIView, message: String?) {
        // Set size of done view
        let doneViewWidth = min(view.frame.width, view.frame.height) / 2
        var originX: CGFloat, originY: CGFloat
        if (UIDevice.current.systemVersion as NSString).floatValue >= 8.0 {
            originX = (view.frame.width - doneViewWidth) / 2
            originY = (view.frame.height - doneViewWidth) / 2
        } else {
            let isLandscape = UIDevice.current.orientation.isLandscape
            originX = ((isLandscape ? view.frame.height : view.frame.width) - doneViewWidth) / 2
            originY = ((isLandscape ? view.frame.width : view.frame.height) - doneViewWidth) / 2
        }
        let doneViewFrame = CGRect(
            x: originX,
            y: originY,
            width: doneViewWidth,
            height: doneViewWidth)
        self.doneView.layer.cornerRadius = 8
        self.doneView.frame = doneViewFrame

        // Set message
        self.doneView.setMessage(message)
        
        // Start animation
        self.doneView.alpha = 0
        view.addSubview(self.doneView)
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.doneView.alpha = 1
        }, completion: { (result: Bool) -> Void in
            self.doneView.drawCheck({ () -> Void in
                let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                        self.doneView.alpha = 0
                        }, completion: { (result: Bool) -> Void in
                            self.doneView.removeFromSuperview()
                            self.doneView.clear()
                    }) 
                }
            })
        }) 
    }
}
