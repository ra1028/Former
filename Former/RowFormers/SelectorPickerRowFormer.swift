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

public class SelectorPickerRowFormer: RowFormer {
    
    override public var canBecomeEditing: Bool {
        return self.enabled
    }
    
    public var onValueChanged: ((Int, String) -> Void)?
    public var valueTitles: [String] = []
    public var selectedRow: Int = 0
    public var showsSelectionIndicator: Bool?
    public var pickerBackgroundColor: UIColor?
    public var inputAccessoryView: UIView?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    public var titleAlignment: NSTextAlignment?
    public var titleNumberOfLines: Int?
    
    public var displayTextFont: UIFont?
    public var displayTextColor: UIColor?
    public var displayTextDisabledColor: UIColor?
    
    private lazy var inputView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    public init<T: UITableViewCell where T: SelectorPickerFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        onValueChanged: ((Int, String) -> Void)? = nil) {
            super.init(cellType: cellType, registerType: registerType)
            self.onValueChanged = onValueChanged
    }
    
    public override func initializeRowFomer() {
        
        super.initializeRowFomer()
        self.titleDisabledColor = .lightGrayColor()
        self.displayTextColor = .lightGrayColor()
        self.displayTextDisabledColor = .lightGrayColor()
    }
    
    public override func update() {
        
        super.update()
        
        self.inputView.selectRow(self.selectedRow, inComponent: 0, animated: false)
        self.inputView.showsSelectionIndicator =? self.showsSelectionIndicator
        self.inputView.backgroundColor = self.pickerBackgroundColor
        
        if var row = self.cell as? SelectorPickerFormableRow {
            
            row.selectorPickerView = self.inputView
            row.selectorAccessoryView = self.inputAccessoryView
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            titleLabel?.textAlignment =? self.titleAlignment
            titleLabel?.numberOfLines =? self.titleNumberOfLines
            
            let displayTextLabel = row.formerDisplayLabel()
            displayTextLabel?.text = self.valueTitles[self.selectedRow]
            displayTextLabel?.font =? self.displayTextFont
            displayTextLabel?.textColor = self.enabled ? self.displayTextColor : self.displayTextDisabledColor
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        self.former?.deselect(true)
        
        if self.enabled {
            self.cell?.becomeFirstResponder()
        }
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