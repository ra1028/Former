//
//  InlineDatePickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol InlineDatePickerFormableRow: FormableRow {
    
    func formTitleLabel() -> UILabel?
    func formDisplayLabel() -> UILabel?
}

open class InlineDatePickerRowFormer<T: UITableViewCell>
: BaseRowFormer<T>, Formable, ConfigurableInlineForm where T: InlineDatePickerFormableRow {
    
    // MARK: Public
    
    public typealias InlineCellType = FormDatePickerCell
    
    public let inlineRowFormer: RowFormer
    override open var canBecomeEditing: Bool {
        return enabled
    }
    
    open var date: Date = Date()
    open var displayDisabledColor: UIColor? = .lightGray
    open var titleDisabledColor: UIColor? = .lightGray
    open var displayEditingColor: UIColor?
    open var titleEditingColor: UIColor?
    
    required public init(
        instantiateType: Former.InstantiateType = .Class,
        cellSetup: ((T) -> Void)?) {
            inlineRowFormer = DatePickerRowFormer<InlineCellType>(instantiateType: .Class)
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
        
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        displayLabel?.text = displayTextFromDate?(date) ?? "\(date)"
        
        if enabled {
            if isEditing {
                if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
                if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
                _ = titleEditingColor.map { titleLabel?.textColor = $0 }
                _ = displayEditingColor.map { displayLabel?.textColor = $0 }
            } else {
                _ = titleColor.map { titleLabel?.textColor = $0 }
                _ = displayTextColor.map { displayLabel?.textColor = $0 }
                titleColor = nil
                displayTextColor = nil
            }
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
            _ = titleDisabledColor.map { titleLabel?.textColor = $0 }
            _ = displayDisabledColor.map { displayLabel?.textColor = $0 }
        }
        
        let inlineRowFormer = self.inlineRowFormer as! DatePickerRowFormer<InlineCellType>
        inlineRowFormer.configure {
            $0.onDateChanged(dateChanged)
            $0.enabled = enabled
            $0.date = date
        }.update()
    }
    
    public override func cellSelected(indexPath: IndexPath) {
        former?.deselect(animated: true)
    }
    
    private func dateChanged(date: Date) {
        if enabled {
            self.date = date
            cell.formDisplayLabel()?.text = displayTextFromDate?(date) ?? "\(date)"
            onDateChanged?(date)
        }
    }
    
    public func editingDidBegin() {
        if enabled {
            let titleLabel = cell.formTitleLabel()
            let displayLabel = cell.formDisplayLabel()
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
            _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            _ = displayEditingColor.map { displayLabel?.textColor = $0 }
            isEditing = true
        }
    }
    
    public func editingDidEnd() {
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
        isEditing = false
    }
    
    // MARK: Private
    
    private final var onDateChanged: ((Date) -> Void)?
    private final var displayTextFromDate: ((Date) -> String)?
    private final var titleColor: UIColor?
    private final var displayTextColor: UIColor?
}
