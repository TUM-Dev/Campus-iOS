//
//  PZPullRefreshView.swift
//  PZPullToRefresh
//
//  Created by pixyzehn on 3/19/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

@objc public protocol PZPullToRefreshDelegate: NSObjectProtocol {
    func pullToRefreshDidTrigger(view: PZPullToRefreshView) -> ()
    optional func pullToRefreshLastUpdated(view: PZPullToRefreshView) -> NSDate
}

public class PZPullToRefreshView: UIView {
    
    public enum RefreshState {
        case Normal
        case Pulling
        case Loading
    }

    public var statusTextColor = UIColor.whiteColor()
    public var timeTextColor = UIColor(red:0.95, green:0.82, blue:0.79, alpha:1)
    public var bgColor = UIColor(red:0.82, green:0.44, blue:0.39, alpha:1)
    public var flipAnimatioDutation: CFTimeInterval = 0.18
    public var thresholdValue: CGFloat = 60.0
    public var lastUpdatedKey = "RefreshLastUpdated"
    public var isShowUpdatedTime: Bool = true
    
    public var _isLoading: Bool = false
    public var isLoading: Bool {
        get {
            return _isLoading
        }
        set {
            if state == .Loading {
                _isLoading = true
            } else {
                _isLoading = false
            }
        }
    }
    
    private var _state: RefreshState = .Normal
    public var state: RefreshState {
        get {
           return _state
        }
        set {
            switch newValue {
            case .Normal:
                statusLabel?.text = "Pull down to refresh"
                activityView?.stopAnimating()
                refreshLastUpdatedDate()
                rotateArrowImage(angle: 0)
            case .Pulling:
                statusLabel?.text = "Release to refresh"
                rotateArrowImage(angle: CGFloat(M_PI))
            case .Loading:
                statusLabel?.text = "Loading..."
                activityView?.startAnimating()
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                arrowImage?.hidden = true
                CATransaction.commit()
            }
            _state = newValue
        }
    }
    
    public func rotateArrowImage(angle angle: CGFloat) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(flipAnimatioDutation)
        arrowImage?.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        CATransaction.commit()
    }
    
    public var lastUpdatedLabel: UILabel?
    public var statusLabel: UILabel?
    public var arrowImage: CALayer?
    public var activityView: UIActivityIndicatorView?
    public var delegate: AnyObject?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.backgroundColor = bgColor

        let label: UILabel = UILabel(frame: CGRectMake(0, frame.size.height - 30.0, self.frame.size.width, 20.0))
        label.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        label.font = UIFont.systemFontOfSize(12.0)
        label.textColor = timeTextColor
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        lastUpdatedLabel = label
        if let value: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(lastUpdatedKey) {
            lastUpdatedLabel?.text = value as? String
        } else {
            lastUpdatedLabel?.text = nil
        }
        self.addSubview(label)
        
        let label2: UILabel = UILabel(frame: CGRectMake(0, frame.size.height - 48.0, self.frame.size.width, 20.0))
        label2.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        label2.font = UIFont.boldSystemFontOfSize(14.0)
        label2.textColor = statusTextColor
        label2.backgroundColor = UIColor.clearColor()
        label2.textAlignment = .Center
        statusLabel = label2
        self.addSubview(label2)
        
        let layer: CALayer = CALayer()
        layer.frame = CGRectMake(25.0, frame.size.height - 40.0, 15.0, 25.0)
        layer.contentsGravity = kCAGravityResizeAspect
        layer.contents = UIImage(named: "whiteArrow")?.CGImage
        self.layer.addSublayer(layer)
        arrowImage = layer
        
        let view: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        view.frame = CGRectMake(25.0, frame.size.height - 38.0, 20.0, 20.0)
        self.addSubview(view)
        activityView = view
        
        state = .Normal
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public func refreshLastUpdatedDate() {
        if isShowUpdatedTime {
            if let update = delegate?.respondsToSelector("pullToRefreshLastUpdated:") {
                var date = delegate?.pullToRefreshLastUpdated!(self)
                let formatter = NSDateFormatter()
                formatter.AMSymbol = "AM"
                formatter.PMSymbol = "PM"
                formatter.dateFormat = "yyyy/MM/dd/ hh:mm:a"
                lastUpdatedLabel?.text = "Last Updated: \(formatter.stringFromDate(date!))"
                NSUserDefaults.standardUserDefaults().setObject(lastUpdatedLabel?.text, forKey: lastUpdatedKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    // MARK:ScrollView Methods
    
    public func refreshScrollViewDidScroll(scrollView: UIScrollView) {
        if state == .Loading {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2)
            var offset = max(scrollView.contentOffset.y * -1, 0)
            offset = min(offset, thresholdValue)
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0, 0.0, 0.0)
            UIView.commitAnimations()
        } else if scrollView.dragging {
            var loading: Bool = false
            if state == .Pulling && scrollView.contentOffset.y > -thresholdValue && scrollView.contentOffset.y < 0.0 && !loading {
                state = .Normal
            } else if state == .Normal && scrollView.contentOffset.y < -thresholdValue && !loading {
                state = .Pulling
            }
        }
    }
    
    public func refreshScrollViewDidEndDragging(scrollView: UIScrollView) {
        var loading: Bool = false
        if (scrollView.contentOffset.y <= -thresholdValue && !loading) {
            state = .Loading
            if let load = delegate?.respondsToSelector("pullToRefreshDidTrigger:") {
                delegate?.pullToRefreshDidTrigger(self)
            }
        }
    }
    
    public func refreshScrollViewDataSourceDidFinishedLoading(scrollView: UIScrollView) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.4)
        scrollView.contentInset = UIEdgeInsetsZero
        UIView.commitAnimations()
        arrowImage?.hidden = false
        state = .Normal
    }
    
    deinit {
        delegate = nil
        activityView = nil
        statusLabel = nil
        arrowImage = nil
        lastUpdatedLabel = nil
    }
}
