//
//  SelectorDatePickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SelectorDatePickerFormableRow: FormableRow {
    
    var selectorDatePicker: UIDatePicker? { get set } // Needs NOT to set instance.
    var selectorAccessoryView: UIView? { get set } // Needs NOT to set instance.
    
    func formTitleLabel() -> UILabel?
    func formDisplayLabel() -> UILabel?
    
    func formDefaultDisplayDate() -> NSDate?
    
    func formDefaultDisplayLabelText() -> String? //If formDefaultDisplayDate() returns a real date, the return value from this is ignored
    
}

public class SelectorDatePickerRowFormer<T: UITableViewCell where T: SelectorDatePickerFormableRow>
: BaseRowFormer<T>, Formable, UpdatableSelectorForm {
    
    // MARK: Public
    
    override public var canBecomeEditing: Bool {
        return enabled
    }
    
    public var date: NSDate? = nil
    public var inputAccessoryView: UIView?
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var displayDisabledColor: UIColor? = .lightGrayColor()
    public var titleEditingColor: UIColor?
    public var displayEditingColor: UIColor?
    
    public private(set) final lazy var selectorView: UIDatePicker = { [unowned self] in
        let datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(SelectorDatePickerRowFormer.dateChanged(_:)), forControlEvents: .ValueChanged)
        return datePicker
        }()
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public final func onDateChanged(handler: (NSDate -> Void)) -> Self {
        onDateChanged = handler
        return self
    }
    
    public final func displayTextFromDate(handler: (NSDate -> String)) -> Self {
        displayTextFromDate = handler
        return self
    }
    
    public override func update() {
        super.update()
        
        cell.selectorDatePicker = selectorView
        cell.selectorAccessoryView = inputAccessoryView
        
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        
        
        if let date = date {
            displayLabel?.text = displayTextFromDate?(date) ?? "\(date)"
        } else if let defaultDate = cell.formDefaultDisplayDate()  {
            self.date = defaultDate
            displayLabel?.text = displayTextFromDate?(defaultDate) ?? "\(defaultDate)"
        } else if let defaultDisplayText = cell.formDefaultDisplayLabelText() {
            displayLabel?.text = defaultDisplayText
        }
        
        if self.enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            _ = displayTextColor.map { displayLabel?.textColor = $0 }
            titleColor = nil
            displayTextColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .blackColor() }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .blackColor() }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        former?.deselect(true)
    }
    
    public func editingDidBegin() {
        if enabled {
            let titleLabel = cell.formTitleLabel()
            let displayLabel = cell.formDisplayLabel()
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .blackColor() }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .blackColor() }
            _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            _ = displayEditingColor.map { displayEditingColor = $0 }
            isEditing = true
        }
    }
    
    public func editingDidEnd() {
        isEditing = false
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            _ = displayTextColor.map { displayLabel?.textColor = $0 }
            titleColor = nil
            displayTextColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .blackColor() }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .blackColor() }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    // MARK: Private
    
    private final var onDateChanged: (NSDate -> Void)?
    private final var displayTextFromDate: (NSDate -> String)?
    private final var titleColor: UIColor?
    private final var displayTextColor: UIColor?
    
    private dynamic func dateChanged(datePicker: UIDatePicker) {
        self.date = datePicker.date
        if let date = self.date {
            cell.formDisplayLabel()?.text = displayTextFromDate?(date) ?? "\(date)"
            onDateChanged?(date)
        }
    }
}