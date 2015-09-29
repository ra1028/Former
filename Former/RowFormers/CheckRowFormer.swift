//
//  CheckRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol CheckFormableRow: FormableRow {
    
    func formTitleLabel() -> UILabel?
}

public class CheckRowFormer: RowFormer, FormerValidatable {
    
    public var onValidate: (Bool -> Bool)?
    
    public var onCheckChanged: (Bool -> Void)?
    public var checked = false
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    
    private var titleColor: UIColor?
    
    public init<T : UITableViewCell where T : CheckFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        onCheckChanged: (Bool -> Void)? = nil,
        cellSetup: (T -> Void)? = nil) {
            super.init(cellType: cellType, instantiateType: instantiateType, cellSetup: cellSetup)
            self.onCheckChanged = onCheckChanged
    }
    
    public override func update() {
        super.update()
        
        cell?.accessoryType = checked ? .Checkmark : .None
        if let row = cell as? CheckFormableRow {
            let titleLabel = row.formTitleLabel()
            if enabled {
                titleLabel?.textColor =? titleColor
                titleColor = nil
            } else {
                titleColor ?= titleLabel?.textColor
                titleLabel?.textColor = titleDisabledColor
            }
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)
        former?.deselect(true)
        if enabled {
            checked = !checked
            onCheckChanged?(checked)
            cell?.accessoryType = checked ? .Checkmark : .None
        }
    }
    
    public func validate() -> Bool {
        return onValidate?(checked) ?? true
    }
}