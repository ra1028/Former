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

open class SwitchRowFormer<T: UITableViewCell>
: BaseRowFormer<T>, Formable where T: SwitchFormableRow {
    
    // MARK: Public
    
    open var switched = false
    open var switchWhenSelected = false
    open var titleDisabledColor: UIColor? = .lightGray
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    @discardableResult
    public final func onSwitchChanged(_ handler: @escaping ((Bool) -> Void)) -> Self {
        onSwitchChanged = handler
        return self
    }
    
    open override func cellInitialized(_ cell: T) {
        super.cellInitialized(cell)
        cell.formSwitch().addTarget(self, action: #selector(SwitchRowFormer.switchChanged(_:)), for: .valueChanged)
    }
    
    open override func update() {
        super.update()
        
        if !switchWhenSelected {
            if selectionStyle == nil { selectionStyle = cell.selectionStyle }
            cell.selectionStyle = .none
        } else {
            _ = selectionStyle.map { cell.selectionStyle = $0 }
            selectionStyle = nil
        }
        
        let titleLabel = cell.formTitleLabel()
        let switchButton = cell.formSwitch()
        switchButton.isOn = switched
        switchButton.isEnabled = enabled
        
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            titleColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
        }
    }
    
    public override func cellSelected(indexPath: IndexPath) {        
        former?.deselect(animated: true)
        if switchWhenSelected && enabled {
            let switchButton = cell.formSwitch()
            switchButton.setOn(!switchButton.isOn, animated: true)
            switchChanged(switchButton)
        }
    }
    
    // MARK: Private
    
    private final var onSwitchChanged: ((Bool) -> Void)?
    private final var titleColor: UIColor?
    private final var selectionStyle: UITableViewCellSelectionStyle?
    
    private dynamic func switchChanged(_ switchButton: UISwitch) {
        if self.enabled {
            let switched = switchButton.isOn
            self.switched = switched
            onSwitchChanged?(switched)
        }
    }
}
