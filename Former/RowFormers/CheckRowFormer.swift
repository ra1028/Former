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

public class CheckRowFormer: RowFormer {
    
    public var checkChangedHandler: (Bool -> Void)?
    public var checked = false
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    
    init<T : UITableViewCell where T : CheckFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        checkChangedHandler: (Bool -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)            
            self.checkChangedHandler = checkChangedHandler
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
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
        }
    }
    
    public override func didSelectCell(former: Former, indexPath: NSIndexPath) {
        
        super.didSelectCell(former, indexPath: indexPath)
        former.deselect(true)
        
        if self.enabled {
            self.checked = !self.checked
            self.checkChangedHandler?(self.checked)
            
            self.cell?.accessoryType = self.checked ? .Checkmark : .None
        }
    }
}