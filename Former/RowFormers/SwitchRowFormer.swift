//
//  SwitchRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/27/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SwitchFormableRow: FormableRow {
    
    var observer: FormerObserver { get }
    
    func formerSwitch() -> UISwitch
    func formerTitleLabel() -> UILabel?
}

public class SwitchRowFormer: RowFormer, FormerValidatable {
    
    public var onValidate: (Bool -> Bool)?
    
    public var onSwitchChanged: (Bool -> Void)?
    public var switched: Bool = false
    public var switchWhenSelected = false
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    
    private var titleColor: UIColor?
    private var selectionStyle: UITableViewCellSelectionStyle?
    
    public init<T : UITableViewCell where T : SwitchFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        onSwitchChanged: (Bool -> Void)? = nil,
        cellConfiguration: (T -> Void)? = nil) {
            super.init(cellType: cellType, instantiateType: instantiateType, cellConfiguration: cellConfiguration)
            self.onSwitchChanged = onSwitchChanged
    }
    
    public override func update() {
        super.update()
        
        if !switchWhenSelected {
            selectionStyle ?= cell?.selectionStyle
            cell?.selectionStyle = .None
        } else {
            cell?.selectionStyle =? selectionStyle
            selectionStyle = nil
        }
        
        if let row = cell as? SwitchFormableRow {
            let titleLabel = row.formerTitleLabel()
            let switchButton = row.formerSwitch()
            switchButton.on = switched
            switchButton.enabled = enabled
            
            if enabled {
                titleLabel?.textColor =? titleColor
                titleColor = nil
            } else {
                titleColor ?= titleLabel?.textColor
                titleLabel?.textColor = titleDisabledColor
            }
            
            row.observer.setTargetRowFormer(self,
                control: switchButton,
                actionEvents: [("switchChanged:", .ValueChanged)]
            )
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)
        
        former?.deselect(true)
        if let row = cell as? SwitchFormableRow where switchWhenSelected && enabled {
            let switchButton = row.formerSwitch()
            switchButton.setOn(!switchButton.on, animated: true)
            switchChanged(switchButton)
        }
    }
    
    public func validate() -> Bool {
        return onValidate?(switched) ?? true
    }
    
    public dynamic func switchChanged(switchButton: UISwitch) {
        if self.enabled {
            let switched = switchButton.on
            self.switched = switched
            onSwitchChanged?(switched)
        }
    }
}