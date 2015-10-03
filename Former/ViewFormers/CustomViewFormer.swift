//
//  CustomViewFormer.swift
//  Former
//
//  Created by Ryo Aoyama on 10/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class CustomViewFormer<T: UITableViewHeaderFooterView>: ViewFormer {
    
    // MARK: Public
    
    required public init(
        instantiateType: Former.InstantiateType = .Class,
        viewSetup: (T -> Void)? = nil) {
        super.init(
            viewType: T.self,
            instantiateType: instantiateType,
            viewSetup: viewSetup
            )
    }
    
    public final func viewUpdate(@noescape update: (T -> Void)) {
        update((view as! T))
    }
}