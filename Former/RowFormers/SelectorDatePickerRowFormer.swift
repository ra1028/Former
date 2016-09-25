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
}

open class SelectorDatePickerRowFormer<T: UITableViewCell>
: BaseRowFormer<T>, Formable, UpdatableSelectorForm where T: SelectorDatePickerFormableRow {
    
    // MARK: Public
    
    override open var canBecomeEditing: Bool {
        return enabled
    }
    
    open var date: Date = Date()
    open var inputAccessoryView: UIView?
    open var titleDisabledColor: UIColor? = .lightGray
    open var displayDisabledColor: UIColor? = .lightGray
    open var titleEditingColor: UIColor?
    open var displayEditingColor: UIColor?
    
    public private(set) final lazy var selectorView: UIDatePicker = { [unowned self] in
        let datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(SelectorDatePickerRowFormer.dateChanged(datePicker:)), for: .valueChanged)
        return datePicker
        }()
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    @discardableResult
    public final func onDateChanged(_ handler: @escaping ((Date) -> Void)) -> Self {
        onDateChanged = handler
        return self
    }
    
    @discardableResult
    public final func displayTextFromDate(_ handler: @escaping ((Date) -> String)) -> Self {
        displayTextFromDate = handler
        return self
    }
    
    open override func update() {
        super.update()
        
        cell.selectorDatePicker = selectorView
        cell.selectorAccessoryView = inputAccessoryView
        
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        displayLabel?.text = displayTextFromDate?(date) ?? "\(date)"
        if self.enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            _ = displayTextColor.map { displayLabel?.textColor = $0 }
            titleColor = nil
            displayTextColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    public override func cellSelected(indexPath: IndexPath) {
        former?.deselect(animated: true)
    }
    
    public func editingDidBegin() {
        if enabled {
            let titleLabel = cell.formTitleLabel()
            let displayLabel = cell.formDisplayLabel()
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
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
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    // MARK: Private
    
    private final var onDateChanged: ((Date) -> Void)?
    private final var displayTextFromDate: ((Date) -> String)?
    private final var titleColor: UIColor?
    private final var displayTextColor: UIColor?
    
    private dynamic func dateChanged(datePicker: UIDatePicker) {
        let date = datePicker.date
        self.date = date
        cell.formDisplayLabel()?.text = displayTextFromDate?(date) ?? "\(date)"
        onDateChanged?(date)
    }
}
