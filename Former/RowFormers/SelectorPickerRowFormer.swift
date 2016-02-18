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

public class SelectorPickerItem<S>: PickerItem<S> {
    public let displayTitle: NSAttributedString?
    public init(title: String, displayTitle: NSAttributedString? = nil, value: S? = nil) {
        self.displayTitle = displayTitle
        super.init(title: title, value: value)
    }
}

public class SelectorPickerRowFormer<T: UITableViewCell, S where T: SelectorPickerFormableRow>
: BaseRowFormer<T>, Formable, UpdatableSelectorForm {
    
    // MARK: Public
    
    override public var canBecomeEditing: Bool {
        return enabled
    }
    
    public var pickerItems: [SelectorPickerItem<S>] = []
    public var selectedRow: Int = 0
    public var inputAccessoryView: UIView?
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var displayDisabledColor: UIColor? = .lightGrayColor()
    public var titleEditingColor: UIColor?
    public var displayEditingColor: UIColor?
    
    public private(set) final lazy var selectorView: UIPickerView = { [unowned self] in
        let picker = UIPickerView()
        picker.delegate = self.observer
        picker.dataSource = self.observer
        return picker
        }()
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public final func onValueChanged(handler: (SelectorPickerItem<S> -> Void)) -> Self {
        onValueChanged = handler
        return self
    }
    
    public override func update() {
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
                if titleColor == nil { titleColor = titleLabel?.textColor ?? .blackColor() }
                _ = titleEditingColor.map { titleLabel?.textColor = $0 }
                
                if pickerItems[selectedRow].displayTitle == nil {
                    if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .blackColor() }
                    _ = displayEditingColor.map { displayLabel?.textColor = $0 }
                }
            } else {
                _ = titleColor.map { titleLabel?.textColor = $0 }
                _ = displayTextColor.map { displayLabel?.textColor = $0 }
                titleColor = nil
                displayTextColor = nil
            }
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
            _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            
            if pickerItems[selectedRow].displayTitle == nil {
                if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .blackColor() }
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
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .blackColor() }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .blackColor() }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    // MARK: Private
    
    private final var onValueChanged: (SelectorPickerItem<S> -> Void)?
    private final var titleColor: UIColor?
    private final var displayTextColor: UIColor?
    private final lazy var observer: Observer<T, S> = Observer<T, S>(selectorPickerRowFormer: self)
}

private class Observer<T: UITableViewCell, S where T: SelectorPickerFormableRow>
: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private weak var selectorPickerRowFormer: SelectorPickerRowFormer<T, S>?
    
    init(selectorPickerRowFormer: SelectorPickerRowFormer<T, S>?) {
        self.selectorPickerRowFormer = selectorPickerRowFormer
    }
    
    private dynamic func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
                    selectorPickerRowFormer.displayTextColor = displayLabel?.textColor ?? .blackColor()
                }
                _ = selectorPickerRowFormer.displayEditingColor.map { displayLabel?.textColor = $0 }
            }
        }
    }
    
    private dynamic func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    private dynamic func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let selectorPickerRowFormer = selectorPickerRowFormer else { return 0 }
        return selectorPickerRowFormer.pickerItems.count
    }
    
    private dynamic func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let selectorPickerRowFormer = selectorPickerRowFormer else { return nil }
        return selectorPickerRowFormer.pickerItems[row].title
    }
}