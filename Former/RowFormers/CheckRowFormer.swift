//
//  CheckRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol CheckFormableRow: FormableRow {
    
    func formerTitleLabel() -> UILabel?
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
        cellConfiguration: (T -> Void)? = nil) {
            
            super.init(cellType: cellType, instantiateType: instantiateType, cellConfiguration: cellConfiguration)
            self.onCheckChanged = onCheckChanged
    }
    
    public override func update() {
        
        super.update()
        
        self.cell?.accessoryType = self.checked ? .Checkmark : .None
        
        if let row = self.cell as? CheckFormableRow {
            
            let titleLabel = row.formerTitleLabel()

            if self.enabled {
                titleLabel?.textColor =? self.titleColor
                self.titleColor = nil
            } else {
                self.titleColor ?= titleLabel?.textColor
                titleLabel?.textColor = self.titleDisabledColor
            }
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        self.former?.deselect(true)
        
        if self.enabled {
            
            self.checked = !self.checked
            self.onCheckChanged?(self.checked)
            
            self.cell?.accessoryType = self.checked ? .Checkmark : .None
        }
    }
    
    public func validate() -> Bool {
        
        return self.onValidate?(self.checked) ?? true
    }
}