//
//  CoPieChartView.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 3.07.2023.
//

import UIKit


final class CoPieChartView: UIView {
    
    private static let animationDuration = CFTimeInterval(1)
    private let π = CGFloat.pi
    private let startAngle: CGFloat = 1.5 * CGFloat.pi
    private var strokeWidth = CGFloat(8)
    
    var proportion = CGFloat(0.5) {
        didSet {
            setNeedsLayout()
        }
    }
    
    func configure(width: CGFloat, color: UIColor, proportion: CGFloat, textFont: CGFloat) {
        self.strokeWidth = width
        self.ringlayer.strokeColor = color.cgColor
        self.proportion = proportion
        self.pieLabel.text = "%\(Int(proportion * 100))"
        self.pieLabel.font = .systemFont(ofSize: textFont, weight: .medium)
    }
    
    private lazy var pieLabel: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.textAlignment = .center
        label.textColor = .coText
        return label
    }()
    
    private lazy var circleLayer: CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.coBg.cgColor
        circleLayer.lineWidth = self.strokeWidth
        self.layer.insertSublayer(circleLayer, at: 0)
        return circleLayer
    }()
    
    private lazy var ringlayer: CAShapeLayer = {
        let ringlayer = CAShapeLayer()
        ringlayer.fillColor = UIColor.clear.cgColor
        ringlayer.strokeColor = UIColor.coOrange.cgColor
        ringlayer.lineCap = .round
        ringlayer.lineWidth = self.strokeWidth
        self.layer.addSublayer(ringlayer)
        return ringlayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = (min(frame.size.width, frame.size.height) - strokeWidth - 2)/2
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle + 2 * π, clockwise: true)
        circleLayer.path = circlePath.cgPath
        ringlayer.path = circlePath.cgPath
        ringlayer.strokeEnd = proportion
        addSubview(pieLabel)
        animateRing(from: 0.0, to: proportion)
    }
    
    private func animateRing(from startProportion: CGFloat = 0.0, to endProportion: CGFloat, duration: CFTimeInterval = animationDuration) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = startProportion
        animation.toValue = endProportion
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        ringlayer.strokeStart = startProportion
        ringlayer.strokeEnd = endProportion
        ringlayer.add(animation, forKey: "animateRing")
    }
}
