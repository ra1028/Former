//
//  CustomRowFormer.swift
//  Former
//
//  Created by Ryo Aoyama on 11/5/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public final class CustomRowFormer<T: UITableViewCell>
: BaseRowFormer<T>, Formable {
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
}
