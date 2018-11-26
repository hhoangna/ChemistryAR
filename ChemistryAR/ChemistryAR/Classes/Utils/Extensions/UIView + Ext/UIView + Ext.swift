//
//  UIView + Ext.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

@IBDesignable class DiagonalLine: UIView {
    
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var flip: Bool = false
    @IBInspectable var color: UIColor = UIColor.black
    
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        aPath.lineWidth = self.lineWidth
        if self.flip {
            aPath.move(to: CGPoint(x: 0, y: 0))
            aPath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        } else {
            aPath.move(to: CGPoint(x: 0, y: rect.height))
            aPath.addLine(to: CGPoint(x: rect.width, y: 0))
        }
        aPath.close()
        self.color.set()
        aPath.stroke()
    }
    
}

@IBDesignable
extension UIView {
    
    @IBInspectable
    /// Should the corner be as circle
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
            //abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}

// MARK: - Properties

public extension UIView {
    
    /// Size of view.
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    
    /// Width of view.
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    /// Height of view.
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
}


// MARK: - Finding
extension UIView {
    
    func findNextResponder(withClass cls : AnyClass) -> UIResponder? {
        
        var current : UIResponder? = self;
        
        while let aCurrent = current {
            
            if aCurrent.isKind(of: cls) {
                return current;
            }
            
            current = aCurrent.next;
        }
        
        return nil;
    }
    
    func getSuperView(withClass cls: AnyClass) -> Any? {
        
        var obj = self.superview;
        
        while let anObj = obj {
            
            if anObj.isKind(of: cls) {
                return anObj;
            }else{
                obj = anObj.superview;
            }
            
        }
        
        return nil;
    }
    
    // MARK: - Style
    
    func setBorder(color: UIColor?, lineW: CGFloat) {
        self.layer.borderColor = color?.cgColor;
        self.layer.borderWidth = lineW;
    }
    
    func setRoudary(radius: CGFloat) {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = radius;
        self.clipsToBounds = true
    }
    
    // MARK: - Others
    
    func removeAllConstraints() {
        removeConstraints(self.constraints);
    }
    
    func removeAllConstraintsIncludesSubviews() {
        removeAllConstraints();
        
        for subView in self.subviews {
            subView.removeAllConstraintsIncludesSubviews();
        }
        
    }
    
    func addSubview(_ subView: UIView, edge: UIEdgeInsets) {
        
        let frame = self.bounds.inset(by: edge)
        subView.frame = frame;
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        addSubview(subView);
    }
    
    func addConstaints(top: CGFloat? = nil,
                       right: CGFloat? = nil,
                       bottom: CGFloat? = nil,
                       left: CGFloat? = nil,
                       width: CGFloat? = nil,
                       height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if top != nil { self.addConstaint(top: top!) }
        if right != nil { self.addConstaint(right: right!) }
        if bottom != nil { self.addConstaint(bottom: bottom!) }
        if left != nil { self.addConstaint(left: left!) }
        if width != nil { self.addConstaint(width: width!) }
        if height != nil { self.addConstaint(heigh: height!) }
        
    }
    
    func addConstaint(top offset: CGFloat) {
        guard superview != nil else { return }
        topAnchor.constraint(equalTo: superview!.topAnchor, constant: offset).isActive = true
    }
    
    func addConstaint(right offset: CGFloat) {
        guard superview != nil else { return }
        rightAnchor.constraint(equalTo: superview!.rightAnchor, constant: offset).isActive = true
    }
    
    func addConstaint(left offset: CGFloat) {
        guard superview != nil else { return }
        leftAnchor.constraint(equalTo: superview!.leftAnchor, constant: offset).isActive = true
    }
    
    func addConstaint(bottom offset: CGFloat) {
        guard superview != nil else { return }
        bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: offset).isActive = true
    }
    
    func addConstaint(width offset: CGFloat) {
        guard superview != nil else { return }
        widthAnchor.constraint(equalTo: superview!.widthAnchor, constant: offset).isActive = true
    }
    func addConstaint(heigh offset: CGFloat) {
        guard superview != nil else { return }
        heightAnchor.constraint(equalTo: superview!.heightAnchor, constant: offset).isActive = true
    }
    
    
    func capture() -> UIImage? {
        return capture(scale: 0.0);
    }
    
    func capture(scale: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, scale);
        
        drawHierarchy(in: self.frame, afterScreenUpdates: true);
        
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img;
    }
    
    func setShadowDefault() {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 3.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
    }
    
    func setShadowWithColor(_ color: UIColor) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 2.0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 7
    }
    
    func setShadowButton() {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
    }
    
    enum ViewSide {
        case left, right, top, bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height)
        case .right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height)
        case .top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness)
        case .bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
        }
        
        layer.addSublayer(border)
    }
}

extension UIView {
    
    func addBorders(edges: UIRectEdge = .all, color: UIColor = .black, width: CGFloat = 1.0) {
        
        func createBorder() -> UIView {
            let borderView = UIView(frame: CGRect.zero)
            borderView.translatesAutoresizingMaskIntoConstraints = false
            borderView.backgroundColor = color
            borderView.maskToBounds = true
            borderView.clipsToBounds = true
            return borderView
        }
        
        if (edges.contains(.all) || edges.contains(.top)) {
            let topBorder = createBorder()
            self.addSubview(topBorder)
            NSLayoutConstraint.activate([
                topBorder.topAnchor.constraint(equalTo: self.topAnchor),
                topBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                topBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                topBorder.heightAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.left)) {
            let leftBorder = createBorder()
            self.addSubview(leftBorder)
            NSLayoutConstraint.activate([
                leftBorder.topAnchor.constraint(equalTo: self.topAnchor),
                leftBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                leftBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                leftBorder.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.right)) {
            let rightBorder = createBorder()
            self.addSubview(rightBorder)
            NSLayoutConstraint.activate([
                rightBorder.topAnchor.constraint(equalTo: self.topAnchor),
                rightBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                rightBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                rightBorder.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.bottom)) {
            let bottomBorder = createBorder()
            self.addSubview(bottomBorder)
            NSLayoutConstraint.activate([
                bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                bottomBorder.heightAnchor.constraint(equalToConstant: width)
                ])
        }
    }
}

extension UIView {
    
    public static func load<T: UIView>(nib: String? = nil, owner: Any? = nil) -> T {
        return Bundle.main.loadNibNamed(_:nib != nil ? nib! : String(describing: T.self),
                                        owner: owner,
                                        options: nil)?.first as! T;
    }
}

extension UIView {
    
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: T.self) }
    }
    
}

// MARK: - Methods

public extension UIView {
    
    public typealias Configuration = (UIView) -> Swift.Void
    
    public func config(configurate: Configuration?) {
        configurate?(self)
    }
    
    /// Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

extension UIView {
    
    func searchVisualEffectsSubview() -> UIVisualEffectView? {
        if let visualEffectView = self as? UIVisualEffectView {
            return visualEffectView
        } else {
            for subview in subviews {
                if let found = subview.searchVisualEffectsSubview() {
                    return found
                }
            }
        }
        return nil
    }
    
    /// This is the function to get subViews of a view of a particular type
    /// https://stackoverflow.com/a/45297466/5321670
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    
    
    /// This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T
    /// https://stackoverflow.com/a/45297466/5321670
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

