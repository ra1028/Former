//
//  CustomRowFormer.swift
//  Former
//
//  Created by Ryo Aoyama on 10/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class CustomRowFormer<T: UITableViewCell>: RowFormer {
    
    // MARK: Public
    
    public var typedCell: T {
        return cell as! T
    }
    
    required public init(
        instantiateType: Former.InstantiateType = .Class,
        cellSetup: (T -> Void)? = nil){
        super.init(
            cellType: T.self,
            instantiateType: instantiateType,
            cellSetup: cellSetup
            )
    }
    
    public final func cellUpdate(@noescape update: (T -> Void)) {
        update(typedCell)
    }
}
