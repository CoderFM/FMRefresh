//
//  FMRefreshFooter.swift
//  FMRefresh
//
//  Created by 周发明 on 17/7/5.
//  Copyright © 2017年 周发明. All rights reserved.
//

import UIKit

struct FMRefreshFooterStyle {
    var autoBack: Bool = false
}

class FMRefreshFooter: FMRefresh {

    var originContentHeight: CGFloat = 0;
    
    override func newContentOffset(newOffset: CGPoint) -> Void {
        if self.state == .noMore { // 没有更多数据了
            return;
        }
        
        if self.state == .refreshing { // 任何一个正在刷新  都不能进行重置状态
            return;
        }
        
        let maxOffsetY = target!.contentInset.top + target!.contentSize.height + target!.contentInset.bottom - self.target!.frame.height
        let height = selfHeight
        if newOffset.y > maxOffsetY {// 底部视图即将出现
            if newOffset.y < (maxOffsetY + height) {// header还没有完全显示出来
                self.state = .normal
                let radio = (newOffset.y - maxOffsetY) / height
                self.setRatio(radio)
            } else { // 完全显示出来了
                if target!.isDragging { //拖拽中  即将进入刷新状态
                    self.state = .willRefresh
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
        
        self.originContentHeight = self.target!.contentSize.height
        
        self.originInsetBottom = self.target!.contentInset.bottom;
        var originInset = self.target!.contentInset;
        originInset.bottom += selfHeight
        let offsetY = originInset.top + self.target!.contentSize.height + originInset.bottom - self.target!.frame.height
        UIView.animate(withDuration: 0.2, animations: {
            self.target!.contentInset = originInset;
            self.target!.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
        }) { (finish) in
            self.toRefresh()
        }
    }
    
    override func endRefresh() -> Void {
        var originInset = self.target!.contentInset;
        originInset.bottom -= selfHeight
        let offsetY = originInset.top + self.originContentHeight + selfHeight + originInset.bottom - self.target!.frame.height
        UIView.animate(withDuration: 0.2, animations: {
            self.target!.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
        }) { (finish) in
            self.target!.contentInset = originInset;
            if (self.state != .noMore){
                self.state = .normal
            }
        }
    }
    
    func noMore() -> Void {
        self.state = .noMore
    }

    func reSetNoMore() -> Void {
        self.state = .normal
    }
}
