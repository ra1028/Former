//
//  SelectorDatePickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SelectorDatePickerFormableRow: FormableRow {
    
    var selectorDatePicker: UIDatePicker? { get set } // Not need to set UIDatePicker instance.
    var selectorAccessoryView: UIView? { get set } // Not need to set UIView instance.
    
    func formTitleLabel() -> UILabel?
    func formDisplayLabel() -> UILabel?
}

public class SelectorDatePickerRowFormer<T: UITableViewCell where T: SelectorDatePickerFormableRow>
: CustomRowFormer<T>, FormSelectorInputable, FormerValidatable {
    
    // MARK: Public
    
    override public var canBecomeEditing: Bool {
        return self.enabled
    }
    
    public var onValidate: (NSDate -> Bool)?
    
    public var onDateChanged: (NSDate -> Void)?
    public var inputViewUpdate: (UIDatePicker -> Void)?
    public var displayTextFromDate: (NSDate -> String)?
    public var date: NSDate = NSDate()
    public var inputAccessoryView: UIView?
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var displayDisabledColor: UIColor? = .lightGrayColor()
    public var titleEditingColor: UIColor?
    public var displayEditingColor: UIColor?
    
    private lazy var inputView: UIDatePicker = { [unowned self] in
        let datePicker = UIDatePicker()
        datePicker.addTarget(self, action: "dateChanged:", forControlEvents: .ValueChanged)
        return datePicker
        }()
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public override func update() {
        super.update()
        
        inputViewUpdate?(inputView)
        typedCell.selectorDatePicker = inputView
        typedCell.selectorAccessoryView = inputAccessoryView
        
        let titleLabel = typedCell.formTitleLabel()
        let displayLabel = typedCell.formDisplayLabel()
        displayLabel?.text = displayTextFromDate?(date) ?? "\(date)"
        if self.enabled {
            titleLabel?.textColor =? titleColor
            displayLabel?.textColor =? displayTextColor
            titleColor = nil
            displayTextColor = nil
        } else {
            titleColor ?= titleLabel?.textColor
            displayTextColor ?= displayLabel?.textColor
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)
        former?.deselect(true)
    }
    
    public func validate() -> Bool {
        return onValidate?(date) ?? true
    }
    
    public func editingDidBegin() {
        if enabled {
            let titleLabel = typedCell.formTitleLabel()
            let displayLabel = typedCell.formDisplayLabel()
            titleColor ?= titleLabel?.textColor
            displayTextColor ?= displayLabel?.textColor
            titleLabel?.textColor =? titleEditingColor
            displayEditingColor =? displayEditingColor
            isEditing = true
        }
    }
    
    public func editingDidEnd() {
        isEditing = false
        let titleLabel = typedCell.formTitleLabel()
        let displayLabel = typedCell.formDisplayLabel()
        if enabled {
            titleLabel?.textColor =? titleColor
            displayLabel?.textColor =? displayTextColor
            titleColor = nil
            displayTextColor = nil
        } else {
            titleColor ?= titleLabel?.textColor
            displayTextColor ?= displayLabel?.textColor
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    // MARK: Private
    
    private var titleColor: UIColor?
    private var displayTextColor: UIColor?
    
    private dynamic func dateChanged(datePicker: UIDatePicker) {
        let date = datePicker.date
        self.date = date
        typedCell.formDisplayLabel()?.text = displayTextFromDate?(date) ?? "\(date)"
        onDateChanged?(date)
    }
}