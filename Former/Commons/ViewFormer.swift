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
    
    public var viewHeight: CGFloat = 10
    
    internal init<T: UITableViewHeaderFooterView>(
        viewType: T.Type,
        instantiateType: Former.InstantiateType,
        viewSetup: (T -> Void)? = nil) {
            self.viewType = viewType
            self.instantiateType = instantiateType
            self.viewSetup = { viewSetup?(($0 as! T)) }
            initialized()
    }
    
    public func dynamicViewHeight(handler: ((UITableView, /*section:*/Int) -> CGFloat)) -> Self {
        dynamicViewHeight = handler
        return self
    }
    
    public func initialized() {}
    
    public func update() {
        if let formableView = viewInstance as? FormableView {
            formableView.updateWithViewFormer(self)
        }
    }
    
    // MARK: Internal
    
    internal final var dynamicViewHeight: ((UITableView, Int) -> CGFloat)?
    
    internal final var viewInstance: UITableViewHeaderFooterView {
        if _viewInstance == nil {
            var view: UITableViewHeaderFooterView?
            switch instantiateType {
            case .Class:
                view = viewType.init(reuseIdentifier: nil)
            case .Nib(nibName: let nibName):
                view = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).first as? UITableViewHeaderFooterView
                assert(view != nil, "[Former] Failed to load header footer view from nib (\(nibName)).")
            case .NibBundle(nibName: let nibName, bundle: let bundle):
                view = bundle.loadNibNamed(nibName, owner: nil, options: nil).first as? UITableViewHeaderFooterView
                assert(view != nil, "[Former] Failed to load header footer view from nib (nibName: \(nibName)), bundle: (\(bundle)).")
            }
            _viewInstance = view
            viewInstanceInitialized(view!)
            viewSetup(view!)
        }
        return _viewInstance!
    }
    
    internal func viewInstanceInitialized(view: UITableViewHeaderFooterView) {}
    
    // MARK: Private
    
    private var _viewInstance: UITableViewHeaderFooterView?
    private final let viewType: UITableViewHeaderFooterView.Type
    private final let instantiateType: Former.InstantiateType
    private final let viewSetup: (UITableViewHeaderFooterView -> Void)
}