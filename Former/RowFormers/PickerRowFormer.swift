//
//  PickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/2/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol PickerFormableRow: FormableRow {
    
    func formerPickerView() -> UIPickerView
}

public class PickerRowFormer: RowFormer, FormerValidatable {
    
    public var onValidate: ((Int, String) -> Bool)?
    
    public var onValueChanged: ((Int, String) -> Void)?
    public var valueTitles: [String] = []
    public var selectedRow: Int = 0
    
    public init<T : UITableViewCell where T : PickerFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        onValueChanged: ((Int, String) -> Void)? = nil,
        cellConfiguration: (T -> Void)? = nil) {
            super.init(cellType: cellType, instantiateType: instantiateType, cellConfiguration: cellConfiguration)
            self.onValueChanged = onValueChanged
    }
    
    public override func initialize() {
        super.initialize()
        cellHeight = 216.0
    }
    
    deinit {
        if let row = cell as? PickerFormableRow {
            let picker = row.formerPickerView()
            picker.delegate = nil
            picker.dataSource = nil
        }
    }
    
    public override func update() {
        
        super.update()
        
        cell?.selectionStyle = .None
        if let row = cell as? PickerFormableRow {
            let picker = row.formerPickerView()
            picker.delegate = self
            picker.dataSource = self
            picker.selectRow(selectedRow, inComponent: 0, animated: false)
            picker.userInteractionEnabled = enabled
            picker.alpha = self.enabled ? 1.0 : 0.5
        }
    }
    
    public func validate() -> Bool {
        let row = selectedRow
        return onValidate?(row, valueTitles[row]) ?? true
    }
}

extension PickerRowFormer: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if enabled {
            selectedRow = row
            onValueChanged?(row, valueTitles[row])
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