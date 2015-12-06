//
//  DoneView.swift
//  DoneAnimation
//
//  Created by Ryuta Kibe on 2015/08/22.
//  Copyright (c) 2015 blk. All rights reserved.
//

import UIKit

public class DoneView: UIView {

    // MARK: - private variables
    
    private let lineLayer: CAShapeLayer = CAShapeLayer()
    private var message: String? = nil
    private var messageLabel: UILabel? = nil
    private var blurView: UIView? = nil
    
    // MARK: - public methods
    
    public init() {
        super.init(frame: CGRectZero)
        self.initialize()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    public func setMessage(message: String?) {
        self.message = message
        if let message = self.message {
            if self.messageLabel == nil {
                let messageLabel = UILabel()
                self.messageLabel = messageLabel
                messageLabel.numberOfLines = 1
                messageLabel.textAlignment = .Center
                messageLabel.lineBreakMode = .ByTruncatingTail
                messageLabel.textColor = UIColor.blackColor()
                self.addSubview(messageLabel)
            }
            if let messageLabel = self.messageLabel {
                messageLabel.text = message
                messageLabel.frame = CGRectMake(
                    8,
                    self.frame.height / 5 * 4 - 10,
                    self.frame.width - 16,
                    20)
            }
        }
    }
    
    public func drawCheck(completion: (() -> Void)?) {
        let canvasFrame = CGRectMake(
            self.frame.width / 4,
            message == nil ? self.frame.height / 3 : self.frame.height / 5 * 2,
            self.frame.width / 2,
            self.frame.height / 3)
        let path = UIBezierPath()
        path.moveToPoint(
            CGPointMake(canvasFrame.origin.x, canvasFrame.origin.y + canvasFrame.height / 2))
        path.addLineToPoint(
            CGPointMake(canvasFrame.origin.x + canvasFrame.width / 3, canvasFrame.origin.y))
        path.addLineToPoint(
            CGPointMake(canvasFrame.origin.x + canvasFrame.width, canvasFrame.origin.y + canvasFrame.height))
        self.lineLayer.frame = self.bounds
        self.lineLayer.geometryFlipped = true
        self.lineLayer.path = path.CGPath
        
        self.layer.addSublayer(self.lineLayer)
        self.animate(completion)
    }
    
    public func clear() {
        self.lineLayer.removeFromSuperlayer()
        self.lineLayer.removeAllAnimations()
        self.lineLayer.path = nil

        self.messageLabel?.removeFromSuperview()
        self.messageLabel = nil
        self.message = nil
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.blurView?.frame = self.bounds
    }
    
    // MARK: - private methods
    
    private func initialize() {
        // Initialize properties
        self.clipsToBounds = true
        
        // Set default setting to line
        self.lineLayer.fillColor = UIColor.clearColor().CGColor
        self.lineLayer.anchorPoint = CGPointMake(0, 0)
        self.lineLayer.lineJoin = kCALineJoinRound
        self.lineLayer.lineCap = kCALineCapRound
        self.lineLayer.contentsScale = self.layer.contentsScale
        self.lineLayer.lineWidth = 8
        self.lineLayer.strokeColor = UIColor.blackColor().CGColor
        
        // Generate blur view
        var blurView: UIView
        if #available(iOS 8.0, *) {
            blurView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
        } else {
            blurView = UIView()
            blurView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        }
        self.blurView = blurView
        self.insertSubview(blurView, atIndex: 0)
        blurView.frame = self.bounds
    }
    
    private func animate(completion: (() -> Void)?) {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.2
        pathAnimation.fromValue = NSNumber(float: 0)
        pathAnimation.toValue = NSNumber(float: 1)
        CATransaction.begin()
        if let completion = completion {
            CATransaction.setCompletionBlock(completion)
        }
        self.lineLayer.addAnimation(pathAnimation, forKey:"strokeEndAnimation")
        CATransaction.commit()
    }
}
