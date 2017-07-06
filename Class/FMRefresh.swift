//
//  FMRefresh.swift
//  FMRefresh
//
//  Created by 周发明 on 17/7/5.
//  Copyright © 2017年 周发明. All rights reserved.
//

import UIKit

enum FMRefreshType {
    case header
    case footer
}

enum FMRefreshState {
    case normal
    case willRefresh
    case refreshing
    case willEndRefresh
    case noMore
}

class FMRefresh: UIView {

    var target: UIScrollView? = nil {
        didSet {
            setUp()
        }
    }
    
    var selfHeight: CGFloat = 50;
    
    var type: FMRefreshType = .header
    
    var state: FMRefreshState = .normal {
        didSet(newValue){
            self.updateState()
        }
    }
    
    var originInsetBottom: CGFloat = 0
    
    var originInsetTop: CGFloat = 0
    
    var refreshAction: () -> () = { () in }
    
    init(_ height: CGFloat = 50) {
        selfHeight = height
        super.init(frame: CGRect())
    }
    
    init(_ height: CGFloat = 50, refreshAction:@escaping () -> () = { () in }) {
        selfHeight = height
        self.refreshAction = refreshAction
        super.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(label)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel.frame = self.bounds
    }
    
    deinit {
        if let target = self.target {
            target.removeObserver(self, forKeyPath: "contentSize")
            target.removeObserver(self, forKeyPath: "contentOffset")
            target.removeObserver(self, forKeyPath: "contentInset")
            target.removeObserver(self, forKeyPath: "frame")
        }
    }
}

extension FMRefresh {
    
    func setUp() -> Void {
        target?.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil);
        target?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil);
        target?.addObserver(self, forKeyPath: "contentInset", options: .new, context: nil);
        target?.addObserver(self, forKeyPath: "frame", options: .new, context: nil);
        
        self.originInsetTop = self.target!.contentInset.top;
        self.originInsetBottom = self.target!.contentInset.bottom;
        
        self.setUpFrame()
        self.setUpUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentInset" {
            self.newContentInset(newInset: change![NSKeyValueChangeKey.newKey] as! UIEdgeInsets)
            return
        }
        
        if keyPath == "contentSize" {
            self.newContentSize(newSize: change![NSKeyValueChangeKey.newKey] as! CGSize)
            return
        }
        
        if keyPath == "contentOffset" {
            self.newContentOffset(newOffset: change![NSKeyValueChangeKey.newKey] as! CGPoint)
            return
        }
        
        if keyPath == "frame" {
            self.newFrame(newFrame: change![NSKeyValueChangeKey.newKey] as! CGRect)
            return
        }
    }
    
    func setUpFrame() -> Void {
        if let target = self.target {
            switch type {
            case .header:
                self.frame = CGRect(x: 0, y: -selfHeight, width: self.target!.frame.width, height: selfHeight)
                break
            case .footer:
                self.frame = CGRect(x: 0, y: target.contentSize.height + self.originInsetBottom, width: target.frame.width, height: selfHeight)
                break
            }
        }
    }
    
    func setUpUI() -> Void {
        self.backgroundColor = UIColor.cyan
    }
}

extension FMRefresh {
    
    func refresh(_ action: @escaping () -> ()) -> FMRefresh {
        self.refreshAction = action
        return self
    }
    
    func newContentSize(newSize: CGSize) -> Void {
        self.setUpFrame()
    }
    
    func newContentOffset(newOffset: CGPoint) -> Void {
        if self.state == .refreshing { // 任何一个正在刷新  都不能进行重置状态
            return;
        }
    }
    
    func newContentInset(newInset: UIEdgeInsets) -> Void {
        
        if self.state == .refreshing {
            return
        }
        
        self.originInsetTop = newInset.top;
        self.originInsetBottom = newInset.bottom;
        
        self.setUpFrame()
    }
    
    func newFrame(newFrame: CGRect) -> Void {
        self.setUpFrame()
    }
    
    func setRatio(_ ratio: CGFloat) -> Void {
//        self.textLabel.text = "比例\(ratio)"
    }
    
    func updateState() -> Void {
        self.textLabel.text = self.showText()
    }
    
    func showText() -> String {
        switch self.state {
        case .noMore:
            return "没东西了, 别扯!"
        case .normal:
            return self.type == .header ? "下拉刷新" : "上拉刷新"
        case .refreshing:
            return "正在刷新ing...."
        case .willRefresh:
            return "释放即可刷新"
        case .willEndRefresh:
            return "即将结束刷新"
        }
    }
}

extension FMRefresh {
    
    func willRefresh() -> Void {
        
    }
    
    func toRefresh() -> Void {
        self.refreshAction()
    }
    
    func endRefresh() -> Void {
        
    }
}
