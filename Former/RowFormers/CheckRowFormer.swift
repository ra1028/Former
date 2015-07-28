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
    public var titleTextColor: UIColor?
    
    init<T : UITableViewCell where T : FormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        checked: Bool = false,
        checkChangedHandler: (Bool -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)            
            self.checkChangedHandler = checkChangedHandler
            self.checked = checked
    }
    
    public override func cellConfigure() {
        
        super.cellConfigure()
        
        guard let cell = self.cell as? CheckFormableRow else { return }
        
        let titleLabel = cell.formerTitleLabel()
        
        titleLabel?.text = self.title
        titleLabel?.font = self.titleFont
        titleLabel?.textColor = self.titleTextColor
        self.cell?.accessoryType = self.checked ? .Checkmark : .None
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        
        self.checked = !self.checked
        self.checkChangedHandler?(self.checked)
        
        self.cell?.setSelected(false, animated: true)
        self.cell?.accessoryType = self.checked ? .Checkmark : .None
    }
}