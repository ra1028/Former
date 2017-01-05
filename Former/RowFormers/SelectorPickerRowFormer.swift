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

open class SelectorPickerItem<S>: PickerItem<S> {
    public let displayTitle: NSAttributedString?
    public init(title: String, displayTitle: NSAttributedString? = nil, value: S? = nil) {
        self.displayTitle = displayTitle
        super.init(title: title, value: value)
    }
}

open class SelectorPickerRowFormer<T: UITableViewCell, S>
: BaseRowFormer<T>, Formable, UpdatableSelectorForm where T: SelectorPickerFormableRow {
    
    // MARK: Public
    
    override open var canBecomeEditing: Bool {
        return enabled
    }
    
    open var pickerItems: [SelectorPickerItem<S>] = []
    open var selectedRow: Int = 0
    open var inputAccessoryView: UIView?
    open var titleDisabledColor: UIColor? = .lightGray
    open var displayDisabledColor: UIColor? = .lightGray
    open var titleEditingColor: UIColor?
    open var displayEditingColor: UIColor?
    
    public private(set) final lazy var selectorView: UIPickerView = { [unowned self] in
        let picker = UIPickerView()
        picker.delegate = self.observer
        picker.dataSource = self.observer
        return picker
        }()
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    @discardableResult
    public final func onValueChanged(_ handler: @escaping ((SelectorPickerItem<S>) -> Void)) -> Self {
        onValueChanged = handler
        return self
    }
    
    open override func update() {
        super.update()
        
        selectorView.selectRow(selectedRow, inComponent: 0, animated: false)
        cell.selectorPickerView = selectorView
        cell.selectorAccessoryView = inputAccessoryView
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        if pickerItems.isEmpty {
            displayLabel?.text = ""
        } else {
            displayLabel?.text = pickerItems[selectedRow].title
            _ = pickerItems[selectedRow].displayTitle.map { displayLabel?.attributedText = $0 }
        }
        
        if enabled {
            if isEditing {
                if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
                _ = titleEditingColor.map { titleLabel?.textColor = $0 }
                
                if pickerItems[selectedRow].displayTitle == nil {
                    if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
                    _ = displayEditingColor.map { displayLabel?.textColor = $0 }
                }
            } else {
                _ = titleColor.map { titleLabel?.textColor = $0 }
                _ = displayTextColor.map { displayLabel?.textColor = $0 }
                titleColor = nil
                displayTextColor = nil
            }
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
            _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            
            if pickerItems[selectedRow].displayTitle == nil {
                if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
                _ = displayEditingColor.map { displayLabel?.textColor = $0 }
            }
            isEditing = true
        }
    }
    
    public func editingDidEnd() {
        isEditing = false
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            titleColor = nil
            
            if pickerItems[selectedRow].displayTitle == nil {
                _ = displayTextColor.map { displayLabel?.textColor = $0 }
            }
            displayTextColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    // MARK: Private
    
    fileprivate final var onValueChanged: ((SelectorPickerItem<S>) -> Void)?
    fileprivate final var titleColor: UIColor?
    fileprivate final var displayTextColor: UIColor?
    fileprivate final lazy var observer: Observer<T, S> = Observer<T, S>(selectorPickerRowFormer: self)
}

private class Observer<T: UITableViewCell, S>
: NSObject, UIPickerViewDelegate, UIPickerViewDataSource where T: SelectorPickerFormableRow {
    
    fileprivate weak var selectorPickerRowFormer: SelectorPickerRowFormer<T, S>?
    
    init(selectorPickerRowFormer: SelectorPickerRowFormer<T, S>?) {
        self.selectorPickerRowFormer = selectorPickerRowFormer
    }
    
    fileprivate dynamic func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let selectorPickerRowFormer = selectorPickerRowFormer else { return }
        if selectorPickerRowFormer.enabled {
            selectorPickerRowFormer.selectedRow = row
            let pickerItem = selectorPickerRowFormer.pickerItems[row]
            selectorPickerRowFormer.onValueChanged?(pickerItem)
            
            let cell = selectorPickerRowFormer.cell
            let displayLabel = cell.formDisplayLabel()
            displayLabel?.text = pickerItem.title
            if let displayTitle = pickerItem.displayTitle {
                displayLabel?.attributedText = displayTitle
            } else {
                if selectorPickerRowFormer.displayTextColor == nil {
                    selectorPickerRowFormer.displayTextColor = displayLabel?.textColor ?? .black
                }
                _ = selectorPickerRowFormer.displayEditingColor.map { displayLabel?.textColor = $0 }
            }
        }
    }
    
    fileprivate dynamic func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    fileprivate dynamic func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let selectorPickerRowFormer = selectorPickerRowFormer else { return 0 }
        return selectorPickerRowFormer.pickerItems.count
    }
    
    fileprivate dynamic func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let selectorPickerRowFormer = selectorPickerRowFormer else { return nil }
        return selectorPickerRowFormer.pickerItems[row].title
    }
}
