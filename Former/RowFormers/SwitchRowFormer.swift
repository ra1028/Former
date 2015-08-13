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

public class SwitchRowFormer: RowFormer {
    
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
    
    public override func update() {
        
        super.update()
        
        self.cell?.selectionStyle = self.switchWhenSelected ?
            self.selectionStyle ?? .Default :
            .None
        
        if let row = self.cell as? SwitchFormableRow {
            
            let switchButton = row.formerSwitch()
            switchButton.on = self.switched
            switchButton.onTintColor =? self.switchOnTintColor
            switchButton.thumbTintColor =? self.switchThumbTintColor
            switchButton.tintColor =? self.switchTintColor
            switchButton.enabled = self.enabled
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            
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
    
    public func switchChanged(switchButton: UISwitch) {
        
        if self.enabled {
            let switched = switchButton.on
            self.switched = switched
            self.switchChangedHandler?(switched)
        }
    }
}