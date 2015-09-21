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
        self.cellHeight = 216.0
    }
    
    deinit {
        
        if let row = self.cell as? PickerFormableRow {
            let picker = row.formerPickerView()
            picker.delegate = nil
            picker.dataSource = nil
        }
    }
    
    public override func update() {
        
        super.update()
        
        self.cell?.selectionStyle = .None
        
        if let row = self.cell as? PickerFormableRow {
            
            let picker = row.formerPickerView()
            picker.delegate = self
            picker.dataSource = self
            picker.selectRow(self.selectedRow, inComponent: 0, animated: false)
            picker.userInteractionEnabled = self.enabled
            picker.alpha = self.enabled ? 1.0 : 0.5
        }
    }
    
    public func validate() -> Bool {
        
        let row = self.selectedRow
        return self.onValidate?(row, self.valueTitles[row]) ?? true
    }
}

extension PickerRowFormer: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.enabled {
            self.selectedRow = row
            self.onValueChanged?(row, self.valueTitles[row])
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