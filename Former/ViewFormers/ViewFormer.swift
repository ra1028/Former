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

public class ViewFormer: NSObject {
    
    public private(set) final var view: UITableViewHeaderFooterView?
    public private(set) var instantiateType: Former.InstantiateType
    public var viewHeight: CGFloat = 10.0
    
    private private(set) var viewType: UITableViewHeaderFooterView.Type
    private final let viewConfiguration: (UITableViewHeaderFooterView -> Void)
    
    public init<T: UITableViewHeaderFooterView>(
        viewType: T.Type,
        instantiateType: Former.InstantiateType,
        viewConfiguration: (T -> Void)? = nil) {
            self.viewType = viewType
            self.instantiateType = instantiateType
            self.viewConfiguration = {
                if let view = $0 as? T {
                    viewConfiguration?(view)
                } else {
                    assert(false, "[Former]View type is not match at creation time.")
                }
            }
            super.init()
            initialize()
    }
    
    public func initialize() {}
    
    final func viewConfigure() {
        
        if view == nil {
            switch instantiateType {
            case .Class:
                view = viewType.init(reuseIdentifier: nil)
            case .Nib(nibName: let nibName, bundle: let bundle):
                let bundle = bundle ?? NSBundle.mainBundle()
                view = bundle.loadNibNamed(nibName, owner: nil, options: nil).first as? UITableViewHeaderFooterView
                assert(view != nil, "[Former]Failed to load header footer view \(nibName) from nib.")
            }
            _ = view.map {
                $0.contentView.backgroundColor = .clearColor()
                viewConfiguration($0)
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
    
    public final func viewUpdate<T: UITableViewHeaderFooterView>(@noescape update: (T? -> Void)) {
        if let view = view as? T {
            update(view)
        } else {
            assert(false, "[Former]Can't cast view to \(T.self).")
        }
    }
}