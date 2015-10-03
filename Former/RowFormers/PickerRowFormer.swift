//
//  PickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/2/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol PickerFormableRow: FormableRow {
    
    func formPickerView() -> UIPickerView
}

public class PickerRowFormer<T: UITableViewCell where T: PickerFormableRow>
: CustomRowFormer<T>, FormerValidatable {
    
    // MARK: Public
    
    public var onValidate: ((Int, String) -> Bool)?
    
    public var onValueChanged: ((Int, String) -> Void)?
    public var valueTitles: [String] = []
    public var selectedRow: Int = 0
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public override func initialized() {
        super.initialized()
        cellHeight = 216.0
    }
    
    deinit {
        let picker = typedCell.formPickerView()
        picker.delegate = nil
        picker.dataSource = nil
    }
    
    public override func update() {
        super.update()
        
        typedCell.selectionStyle = .None
        let picker = typedCell.formPickerView()
        picker.delegate = observer
        picker.dataSource = observer
        picker.selectRow(selectedRow, inComponent: 0, animated: false)
        picker.userInteractionEnabled = enabled
        picker.alpha = self.enabled ? 1.0 : 0.5
    }
    
    public func validate() -> Bool {
        let row = selectedRow
        return onValidate?(row, valueTitles[row]) ?? true
    }
    
    // MARK: Private
    
    private lazy var observer: Observer<T> = { [unowned self] in
        Observer<T>(pickerRowFormer: self)
        }()
}

private class Observer<T: UITableViewCell where T: PickerFormableRow>
: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private weak var pickerRowFormer: PickerRowFormer<T>?
    
    init(pickerRowFormer: PickerRowFormer<T>) {
        self.pickerRowFormer = pickerRowFormer
    }
    
    private dynamic func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let pickerRowFormer = pickerRowFormer else { return }
        if pickerRowFormer.enabled {
            pickerRowFormer.selectedRow = row
            pickerRowFormer.onValueChanged?(row, pickerRowFormer.valueTitles[row])
        }
    }
    
    private dynamic func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    private dynamic func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let pickerRowFormer = pickerRowFormer else { return 0 }
        return pickerRowFormer.valueTitles.count
    }
    
    private dynamic func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let pickerRowFormer = pickerRowFormer else { return nil }
        return pickerRowFormer.valueTitles[row]
    }
}