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

public class PickerRowFormer: RowFormer {
    
    public var valueChangedHandler: ((Int, String) -> Void)?
    public var valueTitles: [String] = []
    public var selectedRow: Int = 0
    public var showsSelectionIndicator: Bool?
    
    init<T : UITableViewCell where T : PickerFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        valueChangedHandler: ((Int, String) -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.valueChangedHandler = valueChangedHandler
    }
    
    public override func initializeRowFomer() {
        
        super.initializeRowFomer()
        self.cellHeight = 216.0
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    deinit {
        
        if let row = self.cell as? PickerFormableRow {
            let datePicker = row.formerPickerView()
            datePicker.delegate = nil
            datePicker.dataSource = nil
        }
    }
    
    public override func cellConfigure(cell: UITableViewCell) {
        
        super.cellConfigure(cell)
        
        if let row = self.cell as? PickerFormableRow {
            
            let datePicker = row.formerPickerView()
            datePicker.delegate = self
            datePicker.dataSource = self
            datePicker.selectRow(self.selectedRow, inComponent: 0, animated: false)
            datePicker.showsSelectionIndicator =? self.showsSelectionIndicator
            datePicker.userInteractionEnabled = self.enabled
        }
    }
}

extension PickerRowFormer: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.enabled {
            self.selectedRow = row
            self.valueChangedHandler?(row, self.valueTitles[row])
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