//
//  BaseRowFormer.swift
//  Former
//
//  Created by Ryo Aoyama on 10/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class BaseRowFormer<T: UITableViewCell>: RowFormer {
    
    // MARK: Public
    
    public var cell: T {
        return cellInstance as! T
    }
    
    required public init(
        instantiateType: Former.InstantiateType = .Class,
        cellSetup: ((T) -> Void)? = nil) {
        super.init(
            cellType: T.self,
            instantiateType: instantiateType,
            cellSetup: cellSetup
            )
    }

    @discardableResult
    public final func cellSetup(_ handler: @escaping ((T) -> Void)) -> Self {
        cellSetup = { handler(($0 as! T)) }
        return self
    }
    
    @discardableResult
    public final func cellUpdate(_ update: ((T) -> Void)) -> Self {
        update(cell)
        return self
    }
    
    open func cellInitialized(_ cell: T) {}
    
    // MARK: Internal
    
    override func cellInstanceInitialized(_ cell: UITableViewCell) {
        cellInitialized(cell as! T)
    }
}
