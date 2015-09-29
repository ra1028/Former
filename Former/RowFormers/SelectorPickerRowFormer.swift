//
//  SelectorPickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SelectorPickerFormableRow: FormableRow {
    
    var selectorPickerView: UIPickerView? { get set } // Not need to set UIPickerView instance.
    var selectorAccessoryView: UIView? { get set } // Not need to set UIView instance.
    
    func formTitleLabel() -> UILabel?
    func formDisplayLabel() -> UILabel?
}

public class SelectorPickerRowFormer: RowFormer, FormerValidatable {
    
    override public var canBecomeEditing: Bool {
        return enabled
    }
    
    public var onValidate: ((Int, String) -> Bool)?
    
    public var onValueChanged: ((Int, String) -> Void)?
    public var valueTitles: [String] = []
    public var selectedRow: Int = 0
    public var inputAccessoryView: UIView?
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var displayDisabledColor: UIColor? = .lightGrayColor()

    private var titleColor: UIColor?
    private var displayTextColor: UIColor?
    
    private lazy var inputView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    public init<T: UITableViewCell where T: SelectorPickerFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        onValueChanged: ((Int, String) -> Void)? = nil,
        cellSetup: (T -> Void)? = nil) {
            super.init(cellType: cellType, instantiateType: instantiateType, cellSetup: cellSetup)
            self.onValueChanged = onValueChanged
    }
    
    public override func update() {
        super.update()
        
        inputView.selectRow(selectedRow, inComponent: 0, animated: false)
        if let row = cell as? SelectorPickerFormableRow {
            row.selectorPickerView = inputView
            row.selectorAccessoryView = inputAccessoryView
            let titleLabel = row.formTitleLabel()
            let displayLabel = row.formDisplayLabel()
            if valueTitles.isEmpty {
                displayLabel?.text = ""
            } else {
                displayLabel?.text = valueTitles[selectedRow]
            }
            
            if enabled {
                titleLabel?.textColor =? titleColor
                displayLabel?.textColor =? displayTextColor
                self.titleColor = nil
                self.displayTextColor = nil
            } else {
                self.titleColor ?= titleLabel?.textColor
                self.displayTextColor ?= displayLabel?.textColor
                titleLabel?.textColor = titleDisabledColor
                displayLabel?.textColor = displayDisabledColor
            }
        }
    }
    
    public final func inputViewUpdate(@noescape update: (UIPickerView -> Void)) {
        update(inputView)
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)
        former?.deselect(true)
        if enabled {
            cell?.becomeFirstResponder()
        }
    }
    
    public func validate() -> Bool {
        let row = selectedRow
        let selectedTitle = valueTitles[row]
        return onValidate?(row, selectedTitle) ?? true
    }
}

extension SelectorPickerRowFormer: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if enabled {
            selectedRow = row
            let selectedTitle = valueTitles[row]
            onValueChanged?(row, selectedTitle)
            if let row = cell as? SelectorPickerFormableRow {
                let displayTextLabel = row.formDisplayLabel()
                displayTextLabel?.text = selectedTitle
            }
        }
    }
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return valueTitles.count
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return valueTitles[row]
    }
}