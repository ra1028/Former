//
//  CustomViewFormer.swift
//  Former
//
//  Created by Ryo Aoyama on 11/7/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class CustomViewFormer<T: UITableViewHeaderFooterView>
: BaseViewFormer<T> {
    
    // MARK: Public
    
    required public init(instantiateType: Former.InstantiateType = .Class, viewSetup: (T -> Void)? = nil) {
            super.init(instantiateType: instantiateType, viewSetup: viewSetup)
    }
}