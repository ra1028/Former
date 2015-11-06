//
//  BaseRowFormer.swift
//  Former
//
//  Created by Ryo Aoyama on 10/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class BaseRowFormer<T: UITableViewCell>: RowFormer {
    
    // MARK: Public
    
    public var cell: T {
        return cellInstance as! T
    }
    
    required public init(
        instantiateType: Former.InstantiateType = .Class,
        cellSetup: (T -> Void)? = nil) {
        super.init(
            cellType: T.self,
            instantiateType: instantiateType,
            cellSetup: cellSetup
            )
    }
    
    public final func cellSetup(handler: (T -> Void)) -> Self {
        cellSetup = { handler(($0 as! T)) }
        return self
    }
    
    public final func cellUpdate(@noescape update: (T -> Void)) -> Self {
        update(cell)
        return self
    }
    
    public func cellInitialized(cell: T) {}
    
    // MARK: Internal
    
    override func cellInstanceInitialized(cell: UITableViewCell) {
        cellInitialized(cell as! T)
    }
}
