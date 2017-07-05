//
//  UIScrollView+Extension.swift
//  FMRefresh
//
//  Created by 周发明 on 17/7/5.
//  Copyright © 2017年 周发明. All rights reserved.
//

import UIKit

extension UIScrollView{
    
    private static let headerAssociation = FMObjectAssociation<FMRefreshHeader>()
    private static let footerAssociation = FMObjectAssociation<FMRefreshFooter>()
    
    var fm_footer: FMRefreshFooter? {
        get {
            return (UIScrollView.footerAssociation[self])
        }
        set {
            if let footer = self.fm_footer {
                footer.removeFromSuperview()
            }
            addSubview(newValue!)
            newValue?.type = .footer
            newValue?.target = self;
            UIScrollView.footerAssociation[self] = newValue
        }
    }
    
    var fm_header: FMRefreshHeader? {
        get {
            return (UIScrollView.headerAssociation[self])
        }
        set {
            if let header = self.fm_header {
                header.removeFromSuperview()
            }
            addSubview(newValue!)
            newValue?.type = .header
            newValue?.target = self;
            UIScrollView.headerAssociation[self] = newValue
        }
    }
}

public final class FMObjectAssociation<T: AnyObject> {
    private let policy: objc_AssociationPolicy
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }
    
    public subscript(index: AnyObject) -> T? {
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}
