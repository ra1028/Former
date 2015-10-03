//
//  SwitchRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/27/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SwitchFormableRow: FormableRow {
    
    func formSwitch() -> UISwitch
    func formTitleLabel() -> UILabel?
}

public class SwitchRowFormer<T: UITableViewCell where T: SwitchFormableRow>
: CustomRowFormer<T>, FormerValidatable {
    
    // MARK: Public
    
    public var onValidate: (Bool -> Bool)?
    
    public var onSwitchChanged: (Bool -> Void)?
    public var switched: Bool = false
    public var switchWhenSelected = false
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    deinit {
        if let row = cell as? SwitchFormableRow {
            row.formSwitch().removeTarget(self, action: "switchChanged:", forControlEvents: .ValueChanged)
        }
    }
    
    public override func cellInitialized(cell: UITableViewCell) {
        super.cellInitialized(cell)
        if let row = cell as? SwitchFormableRow {
            row.formSwitch().addTarget(self, action: "switchChanged:", forControlEvents: .ValueChanged)
        }
    }
    
    public override func update() {
        super.update()
        
        if !switchWhenSelected {
            selectionStyle ?= cell.selectionStyle
            cell.selectionStyle = .None
        } else {
            cell.selectionStyle =? selectionStyle
            selectionStyle = nil
        }
        
        if let row = cell as? SwitchFormableRow {
            let titleLabel = row.formTitleLabel()
            let switchButton = row.formSwitch()
            switchButton.on = switched
            switchButton.enabled = enabled
            
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
        if let row = cell as? SwitchFormableRow where switchWhenSelected && enabled {
            let switchButton = row.formSwitch()
            switchButton.setOn(!switchButton.on, animated: true)
            switchChanged(switchButton)
        }
    }
    
    public func validate() -> Bool {
        return onValidate?(switched) ?? true
    }
    
    // MARK: Private
    
    private var titleColor: UIColor?
    private var selectionStyle: UITableViewCellSelectionStyle?
    
    private dynamic func switchChanged(switchButton: UISwitch) {
        if self.enabled {
            let switched = switchButton.on
            self.switched = switched
            onSwitchChanged?(switched)
        }
    }
}