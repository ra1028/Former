//
//  UITableViewCellExt.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    // For SelectorRow
    
    override public var inputView: UIView? {
        if let pickerRow = self as? SelectorPickerFormableRow {
            return pickerRow.selectorPickerView
        } else if let datePickerRow = self as? SelectorDatePickerFormableRow {
            return datePickerRow.selectorDatePicker
        }
        return super.inputView
    }
    
    override public var inputAccessoryView: UIView? {
        if let pickerRow = self as? SelectorPickerFormableRow {
            return pickerRow.selectorAccessoryView
        } else if let datePickerRow = self as? SelectorDatePickerFormableRow {
            return datePickerRow.selectorAccessoryView
        }
        return super.inputAccessoryView
    }
    
    override public func canBecomeFirstResponder() -> Bool {
        if self is SelectorPickerFormableRow ||
            self is SelectorDatePickerFormableRow {
                return true
        }        
        return super.canBecomeFirstResponder()
    }
}