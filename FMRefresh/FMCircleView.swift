//
//  FMCircleView.swift
//  FMRefresh
//
//  Created by 周发明 on 17/7/6.
//  Copyright © 2017年 周发明. All rights reserved.
//

import UIKit

enum FMCircleViewStyle {
    case hollow
    case solid
}


class FMCircleView: UIView {
    
    static let AnimationForKey = "AnimationForKey"
    
    var progress: CGFloat = 0.0 {
        didSet{
            self.updateProgress()
        }
    }
    
    var style: FMCircleViewStyle = .hollow
    
    var strokeColor: UIColor = UIColor.orange
    
    var fillColor: UIColor = UIColor.white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharpLayer.strokeColor = self.strokeColor.cgColor
        self.sharpLayer.fillColor = self.fillColor.cgColor
        self.sharpLayer.strokeStart = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() -> Void {
        self.sharpLayer.strokeEnd = 0
        self.displayLink.isPaused = false
//        self.sharpLayer.strokeEnd = 0.99
//        let animation = CABasicAnimation(keyPath: "transform.scale")
//        animation.duration = 0.25
//        animation.toValue = 1.3
//        animation.repeatCount = Float(Int.max)
//        self.layer.add(animation, forKey: FMCircleView.AnimationForKey)
    }
    
    func stopAnimation() -> Void {
        self.displayLink.isPaused = true
//        self.layer.removeAnimation(forKey: FMCircleView.AnimationForKey)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sharpLayer.frame = self.bounds
    }
    
    lazy var sharpLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.addSublayer(layer)
        return layer
    }()
    
    lazy var displayLink: CADisplayLink = {
        let link = CADisplayLink(target: self, selector: #selector(updateLink))
        link.isPaused = true
        link.add(to: RunLoop.current, forMode: .commonModes)
        return link
    }()
    
    func updateProgress() -> Void {
        switch self.style {
        case .hollow:
            self.sharpLayer.strokeColor = self.strokeColor.cgColor
            self.sharpLayer.fillColor = UIColor.clear.cgColor
            let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height * 0.5), radius: self.bounds.width * 0.5, startAngle: 0, endAngle: (CGFloat(M_PI) * 2 * self.progress), clockwise: true)
            self.sharpLayer.path = path.cgPath
            break
        case .solid:
            self.sharpLayer.strokeColor = self.fillColor.cgColor
            self.sharpLayer.fillColor = self.fillColor.cgColor
            let path = UIBezierPath()
            path.move(to: CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height * 0.5))
            path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height * 0.5))
            path.addArc(withCenter: CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height * 0.5), radius: self.bounds.width * 0.5, startAngle: 0, endAngle: (CGFloat(M_PI) * 2 * self.progress), clockwise: true)
            self.sharpLayer.path = path.cgPath
            break
        }
    }
    
    func updateLink() -> Void {
        var progress = self.progress
        progress += 0.01
        if progress > 1 {
            progress = 0
        }
        self.progress = progress
    }
}
