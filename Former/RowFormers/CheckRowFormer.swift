//
//  CheckRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol CheckFormableRow: FormableRow {
    
    func formTitleLabel() -> UILabel?
}

public class CheckRowFormer<T: UITableViewCell where T: CheckFormableRow>
: BaseRowFormer<T>, Formable {
    
    // MARK: Public
    
    public var checked = false
    public var customCheckView: UIView?
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public final func onCheckChanged(handler: (Bool -> Void)) -> Self {
        onCheckChanged = handler
        return self
    }
    
    public override func update() {
        super.update()
        
        if let customCheckView = customCheckView {
            cell.accessoryView = customCheckView
            customCheckView.hidden = checked ? false : true
        } else {
            cell.accessoryType = checked ? .Checkmark : .None
        }
        let titleLabel = cell.formTitleLabel()
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            titleColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .blackColor() }
            titleLabel?.textColor = titleDisabledColor
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        former?.deselect(true)
        if enabled {
            checked = !checked
            onCheckChanged?(checked)
            if let customCheckView = customCheckView {
                cell.accessoryView = customCheckView
                customCheckView.hidden = checked ? false : true
            } else {
                cell.accessoryType = checked ? .Checkmark : .None
            }
        }
    }
    
    // MARK: Private
    
    private final var titleColor: UIColor?
    private final var onCheckChanged: (Bool -> Void)?
}