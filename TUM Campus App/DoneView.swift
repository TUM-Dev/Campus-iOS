//
//  DoneView.swift
//  DoneAnimation
//
//  Created by Ryuta Kibe on 2015/08/22.
//  Copyright (c) 2015 blk. All rights reserved.
//

import UIKit

open class DoneView: UIView {

    // MARK: - private variables
    
    fileprivate let lineLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var message: String? = nil
    fileprivate var messageLabel: UILabel? = nil
    fileprivate var blurView: UIView? = nil
    
    // MARK: - public methods
    
    public init() {
        super.init(frame: CGRect.zero)
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
    
    open func setMessage(_ message: String?) {
        self.message = message
        if let message = self.message {
            if self.messageLabel == nil {
                let messageLabel = UILabel()
                self.messageLabel = messageLabel
                messageLabel.numberOfLines = 1
                messageLabel.textAlignment = .center
                messageLabel.lineBreakMode = .byTruncatingTail
                messageLabel.textColor = UIColor.black
                self.addSubview(messageLabel)
            }
            if let messageLabel = self.messageLabel {
                messageLabel.text = message
                messageLabel.frame = CGRect(
                    x: 8,
                    y: self.frame.height / 5 * 4 - 10,
                    width: self.frame.width - 16,
                    height: 20)
            }
        }
    }
    
    open func drawCheck(_ completion: (() -> Void)?) {
        let canvasFrame = CGRect(
            x: self.frame.width / 4,
            y: message == nil ? self.frame.height / 3 : self.frame.height / 5 * 2,
            width: self.frame.width / 2,
            height: self.frame.height / 3)
        let path = UIBezierPath()
        path.move(
            to: CGPoint(x: canvasFrame.origin.x, y: canvasFrame.origin.y + canvasFrame.height / 2))
        path.addLine(
            to: CGPoint(x: canvasFrame.origin.x + canvasFrame.width / 3, y: canvasFrame.origin.y))
        path.addLine(
            to: CGPoint(x: canvasFrame.origin.x + canvasFrame.width, y: canvasFrame.origin.y + canvasFrame.height))
        self.lineLayer.frame = self.bounds
        self.lineLayer.isGeometryFlipped = true
        self.lineLayer.path = path.cgPath
        
        self.layer.addSublayer(self.lineLayer)
        self.animate(completion)
    }
    
    open func clear() {
        self.lineLayer.removeFromSuperlayer()
        self.lineLayer.removeAllAnimations()
        self.lineLayer.path = nil

        self.messageLabel?.removeFromSuperview()
        self.messageLabel = nil
        self.message = nil
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.blurView?.frame = self.bounds
    }
    
    // MARK: - private methods
    
    fileprivate func initialize() {
        // Initialize properties
        self.clipsToBounds = true
        
        // Set default setting to line
        self.lineLayer.fillColor = UIColor.clear.cgColor
        self.lineLayer.anchorPoint = CGPoint(x: 0, y: 0)
        self.lineLayer.lineJoin = kCALineJoinRound
        self.lineLayer.lineCap = kCALineCapRound
        self.lineLayer.contentsScale = self.layer.contentsScale
        self.lineLayer.lineWidth = 8
        self.lineLayer.strokeColor = UIColor.black.cgColor
        
        // Generate blur view
        var blurView: UIView
        if #available(iOS 8.0, *) {
            blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        } else {
            blurView = UIView()
            blurView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        }
        self.blurView = blurView
        self.insertSubview(blurView, at: 0)
        blurView.frame = self.bounds
    }
    
    fileprivate func animate(_ completion: (() -> Void)?) {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.2
        pathAnimation.fromValue = NSNumber(value: 0 as Float)
        pathAnimation.toValue = NSNumber(value: 1 as Float)
        CATransaction.begin()
        if let completion = completion {
            CATransaction.setCompletionBlock(completion)
        }
        self.lineLayer.add(pathAnimation, forKey:"strokeEndAnimation")
        CATransaction.commit()
    }
}
