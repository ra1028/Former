//
//  HeaderFooterFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol FormableView: class {
    
    func configureWithViewFormer(viewFormer: ViewFormer)
}

public class ViewFormer {
    
    public private(set) final var view: UITableViewHeaderFooterView?
    public private(set) var viewType: UITableViewHeaderFooterView.Type
    public private(set) var instantiateType: Former.InstantiateType
    public var viewHeight: CGFloat = 10.0
    public var backgroundColor: UIColor?
    
    public init<T: UITableViewHeaderFooterView where T: FormableView>(viewType: T.Type, instantiateType: Former.InstantiateType) {
        
        self.viewType = viewType
        self.instantiateType = instantiateType
        
        self.initialize()
    }
    
    public func initialize() {
        
        self.backgroundColor = .groupTableViewBackgroundColor()
    }
    
    final func viewConfigure() {
        
        if self.view == nil {
            switch self.instantiateType {
            case .Class:
                self.view = self.viewType.init(reuseIdentifier: nil)
            case .Nib(nibName: let nibName, bundle: let bundle):
                let bundle = bundle ?? NSBundle.mainBundle()
                self.view = bundle.loadNibNamed(nibName, owner: nil, options: nil).first as? UITableViewHeaderFooterView
                assert(self.view != nil, "Failed to load header footer view \(nibName) from nib.")
            }
        }
        if let formableView = self.view as? FormableView {
            formableView.configureWithViewFormer(self)
        }
        self.update()
    }
    
    public func update() {
        
        self.view?.contentView.backgroundColor = self.backgroundColor
    }
}