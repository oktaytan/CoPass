//
//  UIView+Ext.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import UIKit
import ViewAnimator

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func applyCircle() {
        let radius = frame.size.height / 2
        clipsToBounds = false
        layer.cornerRadius = radius
    }
    
    func round(corners: UIRectCorner, radius: CGFloat) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.position = self.center
        shapeLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        layer.mask = shapeLayer
    }
    
    func topCornerRadius(radius: CGFloat) {
        clipsToBounds = false
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func bottomCornerRadius(radius: CGFloat) {
        clipsToBounds = false
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func roundAllCorners(radius: CGFloat) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.position = self.center
        shapeLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        layer.mask = shapeLayer
    }
    
    func applyGradientLayer(_ gradientLayer: inout CAGradientLayer,
                            gradientColors: [CGColor],
                            startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                            endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
                            locations: [NSNumber]? = [0.0, 1.0]) {
        gradientLayer.frame = bounds
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public func configureShadow(shadowColor: UIColor, offset: CGSize, shadowRadius: CGFloat, shadowOpacity: Float, cornerRadius: CGFloat, borderColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0.0) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = offset
        layer.shadowRadius = shadowRadius
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
    
    
    public func addAction(target: Any?, action: Selector?) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    public func setFromAnimation(from: Direction = .left, index: Int, offset: CGFloat = 30, delay: Double = 0.0) {
        let fromAnimation = AnimationType.from(direction: from, offset: offset)
        let animationDelay = delay > 0 ? delay : (0.1 * Double(index))
        UIView.animate(views: [self], animations: [fromAnimation], initialAlpha: 0.0, finalAlpha: 1.0, delay: animationDelay, duration: 0.25)
    }
    
    public func setScaleAnimation(index: Int, delay: Double = 0.0) {
        let fromAnimation = AnimationType.zoom(scale: 0.2)
        UIView.animate(views: [self], animations: [fromAnimation], initialAlpha: 0.0, finalAlpha: 1.0, delay: delay, duration: 0.25)
    }
}
