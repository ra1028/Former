//
//  SwitchRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/27/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SwitchFormableRow: FormableRow {
    
    func formerSwitch() -> UISwitch
    func formerTitleLabel() -> UILabel?
}

public class SwitchRowFormer: RowFormer {
    
    private let observer = FormerObserver()
    
    public var switchChangedHandler: (Bool -> Void)?
    public var switched: Bool = false
    public var switchOnTintColor: UIColor?
    public var switchThumbTintColor: UIColor?
    public var switchTintColor: UIColor?
    public var switchWhenSelected = false
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    
    init<T : UITableViewCell where T : SwitchFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        switchChangedHandler: (Bool -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.switchChangedHandler = switchChangedHandler
    }
    
    public override func initializeRowFomer() {
        
        super.initializeRowFomer()
        self.titleDisabledColor = .lightGrayColor()
    }
    
    public override func cellConfigure(cell: UITableViewCell) {
        
        super.cellConfigure(cell)
        
        cell.selectionStyle = self.switchWhenSelected ?
            self.selectionStyle ?? .Default :
            .None
        
        if let row = self.cell as? SwitchFormableRow {
            
            let switchButton = row.formerSwitch()
            self.observer.setTargetRowFormer(self, control: switchButton, actionEvents: [
                ("didChangeSwitch", .ValueChanged)
                ])
            switchButton.on = self.switched
            switchButton.onTintColor =? self.switchOnTintColor
            switchButton.thumbTintColor =? self.switchThumbTintColor
            switchButton.tintColor =? self.switchTintColor
            switchButton.enabled = self.enabled
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
        }
    }
    
    public override func didSelectCell(indexPath: NSIndexPath) {
        
        super.didSelectCell(indexPath)
        self.cell?.setSelected(false, animated: true)
        
        if let row = self.cell as? SwitchFormableRow where self.switchWhenSelected && self.enabled {
            let switchButton = row.formerSwitch()
            switchButton.setOn(!switchButton.on, animated: true)
            self.didChangeSwitch()
        }
    }
    
    public dynamic func didChangeSwitch() {
        
        if let row = self.cell as? SwitchFormableRow where self.enabled {
            let switched = row.formerSwitch().on
            self.switched = switched
            self.switchChangedHandler?(switched)
        }
    }
}