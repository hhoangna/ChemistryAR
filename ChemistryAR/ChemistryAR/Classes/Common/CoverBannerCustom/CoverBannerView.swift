//
//  CoverBannerView.swift
//  ChemistryAR
//
//  Created by Admin on 11/26/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class CoverBannerView: UIView {
    
    static private let eps: CGFloat = 1e-6
    
    public var headerScrollView: UIScrollView!
    public var top: CGFloat = 0
    public fileprivate(set) var bottom: CGFloat = 0
    public fileprivate(set) var isTop: Bool = false
    public fileprivate(set) var isBottom: Bool = true
    fileprivate var completeBlock: ((CoverBannerView) -> Void)?
    fileprivate var startBlock: ((CoverBannerView) -> Void)?
    fileprivate var scrollBlock: ((CoverBannerView, CGFloat) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bottom = frame.size.height
        isTop = false
        isBottom = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIView Delegate
    public override func willMove(toWindow newWindow: UIWindow?) {
        headerScrollView.contentInset = UIEdgeInsets.init(top: bottom, left: 0, bottom: 0, right: 0)
        headerScrollView.scrollIndicatorInsets = UIEdgeInsets.init(top: bottom, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let new = change?[NSKeyValueChangeKey.newKey] {
            let point = (new as! NSValue).cgPointValue
            updateSubViewsWithScrollOffset(newOffset: point)
        }
    }
    
    public func setTopAction(action: @escaping (_ view: CoverBannerView) -> Void) {
        startBlock = action
    }
    
    public func setBottomAction(action: @escaping (_ view: CoverBannerView) -> Void) {
        completeBlock = action
    }
    
    public func setScrollAction(action: @escaping (_ view: CoverBannerView, _ offset: CGFloat) -> Void) {
        scrollBlock = action
    }
    
    // MARK: - Scroll Offset
    fileprivate func updateSubViewsWithScrollOffset(newOffset: CGPoint) {
        var newOffset = newOffset
        let startChangeOffset = -headerScrollView.contentInset.top
        newOffset = CGPoint.init(x: newOffset.x, y: newOffset.y < startChangeOffset ? startChangeOffset : min(newOffset.y, -top))
        let newY = -newOffset.y - bottom
        frame = CGRect.init(x: 0, y: newY, width: frame.size.width, height: frame.size.height)
        let distance = -top - startChangeOffset
        let percent = 1 - (newOffset.y - startChangeOffset) / distance
        
        // Solve Call Back
        if 1.0 - percent > CoverBannerView.eps && percent - 0.0 > CoverBannerView.eps {
            isBottom = false
            isTop = false
        }
        else if isBottom == false && isTop == false {
            if 1.0 - percent < CoverBannerView.eps {
                isTop = true
                if let topAction = completeBlock {
                    topAction(self)
                }
            }
            else if percent - 0.0 < CoverBannerView.eps {
                isBottom = true
                if let bottomAction = startBlock {
                    bottomAction(self)
                }
            }
        }
        if let scrollAction = scrollBlock {
            scrollAction(self, percent)
        }
    }
}
