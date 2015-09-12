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
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    
    public init<T : UITableViewCell where T : CheckFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        onCheckChanged: (Bool -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)            
            self.onCheckChanged = onCheckChanged
    }
    
    public override func initializeRowFomer() {
        
        super.initializeRowFomer()
        self.titleDisabledColor = .lightGrayColor()
    }
    
    public override func update() {
        
        super.update()
        
        self.cell?.accessoryType = self.checked ? .Checkmark : .None
        
        if let row = self.cell as? CheckFormableRow {
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text =? self.title
            titleLabel?.font =? self.titleFont

            if self.enabled {
                titleLabel?.textColor =? self.titleColor
            } else {
                titleLabel?.textColor =? self.titleDisabledColor
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