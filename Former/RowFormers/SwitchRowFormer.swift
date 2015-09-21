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
        
        if !self.switchWhenSelected {
            self.selectionStyle ?= self.cell?.selectionStyle
            self.cell?.selectionStyle = .None
        } else {
            self.cell?.selectionStyle =? self.selectionStyle
            self.selectionStyle = nil
        }
        
        if let row = self.cell as? SwitchFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            let switchButton = row.formerSwitch()
            
            switchButton.on = self.switched
            switchButton.enabled = self.enabled
            
            if self.enabled {
                titleLabel?.textColor =? self.titleColor
                self.titleColor = nil
            } else {
                self.titleColor ?= titleLabel?.textColor
                titleLabel?.textColor = self.titleDisabledColor
            }
            
            row.observer.setTargetRowFormer(self,
                control: switchButton,
                actionEvents: [("switchChanged:", .ValueChanged)]
            )
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        self.former?.deselect(true)
        
        if let row = self.cell as? SwitchFormableRow where self.switchWhenSelected && self.enabled {
            let switchButton = row.formerSwitch()
            switchButton.setOn(!switchButton.on, animated: true)
            self.switchChanged(switchButton)
        }
    }
    
    public func validate() -> Bool {
        
        return self.onValidate?(self.switched) ?? true
    }
    
    public dynamic func switchChanged(switchButton: UISwitch) {
        
        if self.enabled {
            let switched = switchButton.on
            self.switched = switched
            self.onSwitchChanged?(switched)
        }
    }
}