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
        checked: Bool = false,
        checkChangedHandler: (Bool -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)            
            self.checkChangedHandler = checkChangedHandler
            self.checked = checked
    }
    
    public override func configureRowFormer() {
        
        super.configureRowFormer()
        self.titleDisabledColor = .lightGrayColor()
    }
    
    public override func cellConfigure(cell: UITableViewCell) {
        
        super.cellConfigure(cell)
        
        cell.accessoryType = self.checked ? .Checkmark : .None
        
        if let row = cell as? CheckFormableRow {
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
        }
    }
    
    public override func didSelectCell(indexPath: NSIndexPath) {
        
        super.didSelectCell(indexPath)
        
        if self.enabled {
            self.checked = !self.checked
            self.checkChangedHandler?(self.checked)
            
            self.cell?.setSelected(false, animated: true)
            self.cell?.accessoryType = self.checked ? .Checkmark : .None
        }
    }
}