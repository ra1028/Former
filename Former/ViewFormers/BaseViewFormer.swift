//
//  BaseViewFormer.swift
//  Former
//
//  Created by Ryo Aoyama on 10/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class BaseViewFormer<T: UITableViewHeaderFooterView>
: ViewFormer, ConfigurableForm {
    
    // MARK: Public
    
    public var view: T {
        return viewInstance as! T
    }
    
    required public init(
        instantiateType: Former.InstantiateType = .Class,
        viewSetup: (T -> Void)? = nil) {
        super.init(
            viewType: T.self,
            instantiateType: instantiateType,
            viewSetup: viewSetup
            )
    }
    
    public final func viewUpdate(@noescape update: (T -> Void)) -> Self {
        update(view)
        return self
    }
    
    public func viewInitialized(view: T) {}
    
    override func viewInstanceInitialized(view: UITableViewHeaderFooterView) {
        viewInitialized(view as! T)
    }
}