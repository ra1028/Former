//
//  SliderRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SliderFormableRow: FormableRow {
    
    var observer: FormerObserver { get }
    
    func formerSlider() -> UISlider
    func formerTitleLabel() -> UILabel?
    func formerDisplayLabel() -> UILabel?
}

public class SliderRowFormer: RowFormer, FormerValidatable {
    
    public var onValidate: (Float -> Bool)?
    
    public var onValueChanged: (Float -> Void)?
    public var displayTextFromValue: (Float -> String)?
    public var adjustedValueFromValue: (Float -> Float)?
    public var value: Float = 0
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var displayDisabledColor: UIColor? = .lightGrayColor()
    
    private var titleColor: UIColor?
    private var displayColor: UIColor?
    
    public init<T : UITableViewCell where T : SliderFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        onValueChanged: (Float -> Void)? = nil) {
            
            super.init(cellType: cellType, instantiateType: instantiateType)
            self.onValueChanged = onValueChanged
    }
    
    public override func initialize() {
        
        super.initialize()
        self.cellHeight = 88.0
    }
    
    public override func update() {
        
        super.update()
        
        self.cell?.selectionStyle = .None
        
        if let row = self.cell as? SliderFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            let displayLabel = row.formerDisplayLabel()
            let slider = row.formerSlider()
            
            slider.value = self.adjustedValueFromValue?(self.value) ?? self.value
            slider.enabled = self.enabled
            displayLabel?.text = self.displayTextFromValue?(self.value) ?? "\(self.value)"
            
            if self.enabled {
                titleLabel?.textColor =? self.titleColor
                displayLabel?.textColor =? self.displayColor
                self.titleColor = nil
                self.displayColor = nil
            } else {
                self.titleColor ?= titleLabel?.textColor
                self.displayColor ?= displayLabel?.textColor
                titleLabel?.textColor = self.titleDisabledColor
                displayLabel?.textColor = self.displayDisabledColor
            }
            
            row.observer.setTargetRowFormer(self,
                control: slider,
                actionEvents: [("valueChanged:", .ValueChanged)]
            )
        }
    }
    
    public func validate() -> Bool {
        
        let value = self.value
        let adjustedValue = self.adjustedValueFromValue?(value) ?? value
        return self.onValidate?(adjustedValue) ?? true
    }
    
    private dynamic func valueChanged(slider: UISlider) {
        
        if let cell = self.cell as? SliderFormableRow where self.enabled {
            let displayLabel = cell.formerDisplayLabel()
            
            let value = slider.value
            let adjustedValue = self.adjustedValueFromValue?(value) ?? value
            self.value = adjustedValue
            slider.value = adjustedValue
            displayLabel?.text = self.displayTextFromValue?(adjustedValue) ?? "\(adjustedValue)"
            self.onValueChanged?(adjustedValue)
        }
    }
}