//
//  HeaderFooterFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol FormableView {
    
    // Optional
    func configureWithViewFormer(viewFormer: ViewFormer)
}

extension FormableView {
    
    public func configureWithViewFormer(viewFormer: ViewFormer) {}
}

public class ViewFormer {
    
    public final weak var view: UITableViewHeaderFooterView? {
        didSet {
            self.viewConfigureIfFormable()
        }
    }
    public private(set) var viewType: UITableViewHeaderFooterView.Type
    public var viewHeight: CGFloat = 30.0
    public var backgroundColor = UIColor.groupTableViewBackgroundColor()
    
    public init<T: UITableViewHeaderFooterView where T: FormableView>(viewType: T.Type) {
        
        self.viewType = viewType
    }
    
    public func viewConfigureIfFormable() {}
}