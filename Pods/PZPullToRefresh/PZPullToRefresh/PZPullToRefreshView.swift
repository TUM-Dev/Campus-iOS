//
//  PZPullRefreshView.swift
//  PZPullToRefresh
//
//  Created by pixyzehn on 3/19/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

public protocol PZPullToRefreshDelegate: class {
    func pullToRefreshDidTrigger(_ view: PZPullToRefreshView) -> ()
    func pullToRefreshLastUpdated(_ view: PZPullToRefreshView) -> Date
}

public final class PZPullToRefreshView: UIView {
    
    public enum RefreshState {
        case normal
        case pulling
        case loading
    }

    public var statusTextColor = UIColor.white
    public var timeTextColor = UIColor(red: 0.95, green: 0.82, blue: 0.79, alpha: 1)
    public var bgColor = UIColor(red: 0.82, green: 0.44, blue: 0.39, alpha: 1)

    public var flipAnimatioDutation: CFTimeInterval = 0.18
    public var thresholdValue: CGFloat = 60.0

    public var lastUpdatedKey = "RefreshLastUpdated"
    public var isShowUpdatedTime = true
    
    fileprivate var _isLoading = false
    public var isLoading: Bool {
        get {
            return _isLoading
        }
        set {
            _isLoading = state == .loading
        }
    }
    
    fileprivate var _state: RefreshState = .normal
    public var state: RefreshState {
        get {
           return _state
        }
        set {
            switch newValue {
            case .normal:
                statusLabel?.text = "Pull down to refresh"
                activityView?.stopAnimating()
                refreshLastUpdatedDate()
                rotateArrowImage(angle: 0)
            case .pulling:
                statusLabel?.text = "Release to refresh"
                rotateArrowImage(angle: CGFloat(Double.pi))
            case .loading:
                statusLabel?.text = "Loading..."
                activityView?.startAnimating()
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                arrowImage?.isHidden = true
                CATransaction.commit()
            }
            _state = newValue
        }
    }
    
    fileprivate func rotateArrowImage(angle: CGFloat) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(flipAnimatioDutation)
        arrowImage?.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        CATransaction.commit()
    }
    
    public var lastUpdatedLabel: UILabel?
    public var statusLabel: UILabel?
    public var arrowImage: CALayer?
    public var activityView: UIActivityIndicatorView?
    public var delegate: PZPullToRefreshDelegate?
    public var lastUpdatedLabelCustomFormatter: ( (_ date:Date)->String )?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleWidth
        backgroundColor = bgColor

        let label = UILabel(frame: CGRect(x: 0, y: frame.size.height - 30.0, width: frame.size.width, height: 20.0))
        label.autoresizingMask = UIViewAutoresizing.flexibleWidth
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = timeTextColor
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        lastUpdatedLabel = label
        if let time = UserDefaults.standard.object(forKey: lastUpdatedKey) as? String {
            lastUpdatedLabel?.text = time

        } else {
            lastUpdatedLabel?.text = nil
        }
        addSubview(label)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: frame.size.height - 48.0, width: frame.size.width, height: 20.0))
        label2.autoresizingMask = UIViewAutoresizing.flexibleWidth
        label2.font = UIFont.boldSystemFont(ofSize: 14.0)
        label2.textColor = statusTextColor
        label2.backgroundColor = UIColor.clear
        label2.textAlignment = .center
        statusLabel = label2
        addSubview(label2)
        
        let caLayer = CALayer()
        caLayer.frame = CGRect(x: 25.0, y: frame.size.height - 40.0, width: 15.0, height: 25.0)
        caLayer.contentsGravity = kCAGravityResizeAspect
        caLayer.contents = UIImage(named: "whiteArrow")?.cgImage
        arrowImage = caLayer
        layer.addSublayer(caLayer)
        
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.frame = CGRect(x: 25.0, y: frame.size.height - 38.0, width: 20.0, height: 20.0)
        activityView = view
        addSubview(view)
        
        state = .normal
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func refreshLastUpdatedDate() {
        if isShowUpdatedTime {
            if let date = delegate?.pullToRefreshLastUpdated(self) {
                var lastUpdateText:String
                if let customFormatter = self.lastUpdatedLabelCustomFormatter {
                    lastUpdateText = customFormatter(date)
                }else{
                    let formatter = DateFormatter()
                    formatter.amSymbol = "AM"
                    formatter.pmSymbol = "PM"
                    formatter.dateFormat = "yyyy/MM/dd/ hh:mm:a"
                    lastUpdateText = "Last Updated: \(formatter.string(from: date))"
                }
                lastUpdatedLabel?.text = lastUpdateText
                let userDefaults = UserDefaults.standard
                userDefaults.set(lastUpdatedLabel?.text, forKey: lastUpdatedKey)
                userDefaults.synchronize()
            }
        }
    }

    // MARK:ScrollView Methods
    
    public func refreshScrollViewDidScroll(_ scrollView: UIScrollView) {
        if state == .loading {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2)
            var offset = max(scrollView.contentOffset.y * -1, 0)
            offset = min(offset, thresholdValue)
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0, 0.0, 0.0)
            UIView.commitAnimations()

        } else if scrollView.isDragging {
            let loading = false
            if state == .pulling && scrollView.contentOffset.y > -thresholdValue && scrollView.contentOffset.y < 0.0 && !loading {
                state = .normal

            } else if state == .normal && scrollView.contentOffset.y < -thresholdValue && !loading {
                state = .pulling
            }
        }
    }
    
    public func refreshScrollViewDidEndDragging(_ scrollView: UIScrollView) {
        let loading = false
        if scrollView.contentOffset.y <= -thresholdValue && !loading {
            state = .loading
            delegate?.pullToRefreshDidTrigger(self)
        }
    }
    
    public func refreshScrollViewDataSourceDidFinishedLoading(_ scrollView: UIScrollView) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.4)
        scrollView.contentInset = UIEdgeInsets.zero
        UIView.commitAnimations()
        arrowImage?.isHidden = false
        state = .normal
    }
    
}
