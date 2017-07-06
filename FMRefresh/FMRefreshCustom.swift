//
//  FMRefreshCustom.swift
//  FMRefresh
//
//  Created by 周发明 on 17/7/6.
//  Copyright © 2017年 周发明. All rights reserved.
//

import UIKit

class FMRefreshCustom: FMRefreshHeader {
    
    var curveOriginPoint: CGPoint? = nil
    
    override func setUpUI() {
        super.setUpUI()
        
        self.target!.isMultipleTouchEnabled = false
        self.target!.panGestureRecognizer.maximumNumberOfTouches = 1
        
        self.textLabel.isHidden = true
        self.pathLayer.backgroundColor = UIColor.blue.cgColor
        self.circle.strokeColor = UIColor.gray
        self.circle.style = .solid
    }
    
    lazy var pathLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.cyan.cgColor
        self.layer.addSublayer(layer)
        return layer
    }()
    
    lazy var circle: FMCircleView = {
        let view = FMCircleView()
        self.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.pathLayer.frame = self.bounds
        self.curveOriginPoint = CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height);
        
        let width: CGFloat = 30
        self.circle.frame = CGRect(x: (self.bounds.width - width) * 0.5, y: self.bounds.height - width, width: width, height: width)
    }
    
    override func pullWillRefresh() {
        super.pullWillRefresh()
        let point = self.target!.panGestureRecognizer.location(in: self.target!)
        if self.curveOriginPoint == nil {
            self.curveOriginPoint = point
            return
        }
        
        if point.y < self.curveOriginPoint!.y {
            self.curveOriginPoint = nil
            self.pathLayer.path = self.currentPath(CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height))
            return
        }
        
        var y = point.y - self.curveOriginPoint!.y;
        if y > 50 {
            y = 50
        }
        let curve = CGPoint(x: point.x, y: y + selfHeight)
        let path = self.currentPath(curve)
        self.pathLayer.path = path
    
        
        var center = self.circle.center
        center.x = point.x
        self.circle.center = center
    }
    
    override func willRefresh() {
        super.willRefresh()
        self.curveOriginPoint = nil
        self.pathLayer.path = self.currentPath(CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height))
        self.circle.startAnimation()
    }
    
    override func setRatio(_ ratio: CGFloat) {
        self.curveOriginPoint = nil
        self.pathLayer.path = self.currentPath(CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height))
        self.circle.progress = ratio
    }
    
    func currentPath(_ point: CGPoint) -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        path.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height), controlPoint: point)
        path.close()
        return path.cgPath
    }
    
    override func endRefresh() {
        super.endRefresh()
        self.circle.stopAnimation()
    }
}

