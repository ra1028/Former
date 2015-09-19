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
    
    func formerTitleLabel() -> UILabel?
    func formerDisplayLabel() -> UILabel?
}

public class SelectorPickerRowFormer: RowFormer, FormerValidatable {
    
    override public var canBecomeEditing: Bool {
        return self.enabled
    }
    
    public var onValidate: ((Int, String) -> Bool)?
    
    public var onValueChanged: ((Int, String) -> Void)?
    public var inputViewUpdate: (UIPickerView -> Void)?
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
        onValueChanged: ((Int, String) -> Void)? = nil) {
            super.init(cellType: cellType, instantiateType: instantiateType)
            self.onValueChanged = onValueChanged
    }
    
    public override func update() {
        
        super.update()
        
        self.inputViewUpdate?(self.inputView)
        self.inputView.selectRow(self.selectedRow, inComponent: 0, animated: false)
        
        if let row = self.cell as? SelectorPickerFormableRow {
            
            row.selectorPickerView = self.inputView
            row.selectorAccessoryView = self.inputAccessoryView
            
            let titleLabel = row.formerTitleLabel()
            let displayLabel = row.formerDisplayLabel()
            displayLabel?.text = self.valueTitles[self.selectedRow]
            
            if self.enabled {
                titleLabel?.textColor =? self.titleColor
                displayLabel?.textColor =? self.displayTextColor
                self.titleColor = nil
                self.displayTextColor = nil
            } else {
                self.titleColor ?= titleLabel?.textColor
                self.displayTextColor ?= displayLabel?.textColor
                titleLabel?.textColor = self.titleDisabledColor
                displayLabel?.textColor = self.displayDisabledColor
            }
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        self.former?.deselect(true)
        
        if self.enabled {
            self.cell?.becomeFirstResponder()
        }
    }
    
    public func validate() -> Bool {
        
        let row = self.selectedRow
        let selectedTitle = self.valueTitles[row]
        return self.onValidate?(row, selectedTitle) ?? true
    }
}

extension SelectorPickerRowFormer: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.enabled {
            self.selectedRow = row
            let selectedTitle = self.valueTitles[row]
            self.onValueChanged?(row, selectedTitle)
            if let row = self.cell as? SelectorPickerFormableRow {
                let displayTextLabel = row.formerDisplayLabel()
                displayTextLabel?.text = selectedTitle
            }
        }
    }
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.valueTitles.count
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.valueTitles[row]
    }
}