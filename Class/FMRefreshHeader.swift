//
//  FMRefreshHeader.swift
//  FMRefresh
//
//  Created by 周发明 on 17/7/5.
//  Copyright © 2017年 周发明. All rights reserved.
//

import UIKit

class FMRefreshHeader: FMRefresh {
    
    override func newContentOffset(newOffset: CGPoint) -> Void {
        
        if self.state == .refreshing { // 任何一个正在刷新  都不能进行重置状态
            return;
        }
        
        let originOffsetY = -target!.contentInset.top
        let height = selfHeight
        if newOffset.y < originOffsetY {// 可以进入刷新状态
            if newOffset.y > (originOffsetY - height) {// header还没有完全显示出来
                self.state = .normal
                let radio = (originOffsetY - newOffset.y) / height
                self.setRatio(radio)
            } else { // 完全显示出来了
                if target!.isDragging { //拖拽中  即将进入刷新状态
                    self.state = .willRefresh
                    self.pullWillRefresh()
                } else { // 松手了 正在刷新中
                    self.state = .refreshing
                    self.willRefresh()
                }
            }
        } else {
            self.state = .normal
        }
    }
    
    override func willRefresh() -> Void {
        self.originInsetTop = self.target!.contentInset.top;
        var originInset = self.target!.contentInset;
        originInset.top += selfHeight
        UIView.animate(withDuration: 0.2, animations: {
            self.target!.contentInset = originInset;
            self.target!.setContentOffset(CGPoint(x: 0, y: -originInset.top), animated: false)
        }) { (finish) in
            self.toRefresh()
        }
    }
    
    override func endRefresh() -> Void {
        
        var originInset = self.target!.contentInset;
        originInset.top -= selfHeight
        
        UIView.animate(withDuration: 0.2, animations: {
            self.target!.setContentOffset(CGPoint(x: 0, y: -originInset.top), animated: false)
        }) { (finish) in
            self.target!.contentInset = originInset;
            self.state = .normal
        }
    }
    
    func pullWillRefresh() -> Void {
        
    }
    
}
