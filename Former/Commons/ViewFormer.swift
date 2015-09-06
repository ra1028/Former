//
//  HeaderFooterFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol FormableView {
    
    func configureWithViewFormer(viewFormer: ViewFormer)
}

public class ViewFormer {
    
    public private(set) final weak var view: UITableViewHeaderFooterView?
    public internal(set) final var registered: Bool = false
    public private(set) var viewType: UITableViewHeaderFooterView.Type
    public private(set) var registerType: Former.RegisterType
    public var viewHeight: CGFloat = 10.0
    public var backgroundColor: UIColor?
    
    public init<T: UITableViewHeaderFooterView where T: FormableView>(viewType: T.Type, registerType: Former.RegisterType) {
        
        self.viewType = viewType
        self.registerType = registerType
        
        self.configureViewFormer()
    }
    
    public func configureViewFormer() {
        
        self.backgroundColor = .groupTableViewBackgroundColor()
    }
    
    final func viewConfigure(view: UITableViewHeaderFooterView) {
        
        self.view = view
        self.update()
    }
    
    public func update() {
        
        self.view?.contentView.backgroundColor = self.backgroundColor
    }
}