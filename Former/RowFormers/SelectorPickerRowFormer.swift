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

public class SelectorPickerRowFormer<T: UITableViewCell where T: SelectorPickerFormableRow>
: CustomRowFormer<T>, FormSelectorInputable, FormValidatable {
    
    // MARK: Public
    
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
    public var titleEditingColor: UIColor?
    public var displayEditingColor: UIColor?
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public override func update() {
        super.update()
        
        inputView.selectRow(selectedRow, inComponent: 0, animated: false)
        cell.selectorPickerView = inputView
        cell.selectorAccessoryView = inputAccessoryView
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        if valueTitles.isEmpty {
            displayLabel?.text = ""
        } else {
            displayLabel?.text = valueTitles[selectedRow]
        }
        
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            _ = displayTextColor.map { displayLabel?.textColor = $0 }
            self.titleColor = nil
            self.displayTextColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    public final func inputViewUpdate(@noescape update: (UIPickerView -> Void)) {
        update(inputView)
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)
        former?.deselect(true)
    }
    
    public func validate() -> Bool {
        let row = selectedRow
        let selectedTitle = valueTitles[row]
        return onValidate?(row, selectedTitle) ?? true
    }
    
    public func editingDidBegin() {
        if enabled {
            let titleLabel = cell.formTitleLabel()
            let displayLabel = cell.formDisplayLabel()
            if titleColor == nil { titleColor = titleLabel?.textColor }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor }
            _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            _ = displayEditingColor.map { displayLabel?.textColor = $0 }
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
            if titleColor == nil { titleColor = titleLabel?.textColor }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    // MARK: Private
    
    private var titleColor: UIColor?
    private var displayTextColor: UIColor?
    private lazy var observer: Observer<T> = { [unowned self] in
        Observer<T>(selectorPickerRowFormer: self)
        }()
    private lazy var inputView: UIPickerView = { [unowned self] in
        let picker = UIPickerView()
        picker.delegate = self.observer
        picker.dataSource = self.observer
        return picker
        }()
}

private class Observer<T: UITableViewCell where T: SelectorPickerFormableRow>
: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private weak var selectorPickerRowFormer: SelectorPickerRowFormer<T>?
    
    init(selectorPickerRowFormer: SelectorPickerRowFormer<T>?) {
        self.selectorPickerRowFormer = selectorPickerRowFormer
    }
    
    private dynamic func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let selectorPickerRowFormer = selectorPickerRowFormer else { return }
        if selectorPickerRowFormer.enabled {
            selectorPickerRowFormer.selectedRow = row
            let selectedTitle = selectorPickerRowFormer.valueTitles[row]
            selectorPickerRowFormer.onValueChanged?(row, selectedTitle)
            let cell = selectorPickerRowFormer.cell
            let displayTextLabel = cell.formDisplayLabel()
            displayTextLabel?.text = selectedTitle
        }
    }
    
    private dynamic func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    private dynamic func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let selectorPickerRowFormer = selectorPickerRowFormer else { return 0 }
        return selectorPickerRowFormer.valueTitles.count
    }
    
    private dynamic func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let selectorPickerRowFormer = selectorPickerRowFormer else { return nil }
        return selectorPickerRowFormer.valueTitles[row]
    }
}