//
//  HeaderFooterFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol FormableView: class {
    
    func updateWithViewFormer(viewFormer: ViewFormer)
}

public class ViewFormer {
    
    // MARK: Public
    
    public private(set) final var view: UITableViewHeaderFooterView?
    public var viewHeight: CGFloat = 10.0
    
    private final let viewType: UITableViewHeaderFooterView.Type
    private final let instantiateType: Former.InstantiateType
    private final let viewSetup: (UITableViewHeaderFooterView -> Void)
    
    public init<T: UITableViewHeaderFooterView>(
        viewType: T.Type,
        instantiateType: Former.InstantiateType,
        viewSetup: (T -> Void)? = nil) {
            self.viewType = viewType
            self.instantiateType = instantiateType
            self.viewSetup = { viewSetup?(($0 as! T)) }
            initialized()
    }
    
    public func initialized() {}
    
    final func viewConfigure() {
        
        if view == nil {
            switch instantiateType {
            case .Class:
                view = viewType.init(reuseIdentifier: nil)
            case .Nib(nibName: let nibName, bundle: let bundle):
                let bundle = bundle ?? NSBundle.mainBundle()
                view = bundle.loadNibNamed(nibName, owner: nil, options: nil).first as? UITableViewHeaderFooterView
                assert(view != nil, "[Former] Failed to load header footer view from nib (\(nibName)).")
            }
            _ = view.map {
                $0.contentView.backgroundColor = .clearColor()
                viewSetup($0)
            }
        }
        if let formableView = view as? FormableView {
            formableView.updateWithViewFormer(self)
        }
        update()
    }
    
    public func update() {
        if let view = view,
            let formableView = view as? FormableView {
                formableView.updateWithViewFormer(self)
        }
    }
}