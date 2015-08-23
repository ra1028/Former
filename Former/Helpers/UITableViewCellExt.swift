//
//  UITableViewCellExt.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    private static var className: String {
        
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
    static var reuseIdentifier: String {
        
        return self.className
    }
    
    // For SelectorRow
    
    override public var inputView: UIView? {
        
        // TODO: SelectorDatePickerRow
        if let pickerRow = self as? SelectorPickerFormableRow {
            return pickerRow.selectorPickerView
        }
        
        return super.inputView
    }
    
    override public var inputAccessoryView: UIView? {
        
        // TODO: SelectorDatePickerRow
        if let pickerRow = self as? SelectorPickerFormableRow {
            return pickerRow.selectorAccessoryView
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