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
        onValueChanged: (Float -> Void)? = nil,
        cellConfiguration: (T -> Void)? = nil) {
            super.init(cellType: cellType, instantiateType: instantiateType, cellConfiguration: cellConfiguration)
            self.onValueChanged = onValueChanged
    }
    
    public override func initialize() {
        super.initialize()
        cellHeight = 88.0
    }
    
    public override func update() {
        super.update()
        
        cell?.selectionStyle = .None
        if let row = cell as? SliderFormableRow {
            let titleLabel = row.formerTitleLabel()
            let displayLabel = row.formerDisplayLabel()
            let slider = row.formerSlider()
            slider.value = adjustedValueFromValue?(value) ?? value
            slider.enabled = enabled
            displayLabel?.text = displayTextFromValue?(value) ?? "\(value)"
            
            if enabled {
                titleLabel?.textColor =? titleColor
                displayLabel?.textColor =? displayColor
                titleColor = nil
                displayColor = nil
            } else {
                titleColor ?= titleLabel?.textColor
                displayColor ?= displayLabel?.textColor
                titleLabel?.textColor = titleDisabledColor
                displayLabel?.textColor = displayDisabledColor
            }
            
            row.observer.setTargetRowFormer(self,
                control: slider,
                actionEvents: [("valueChanged:", .ValueChanged)]
            )
        }
    }
    
    public func validate() -> Bool {
        let adjustedValue = adjustedValueFromValue?(value) ?? value
        return onValidate?(adjustedValue) ?? true
    }
    
    private dynamic func valueChanged(slider: UISlider) {
        if let cell = cell as? SliderFormableRow where enabled {
            let displayLabel = cell.formerDisplayLabel()
            let value = slider.value
            let adjustedValue = adjustedValueFromValue?(value) ?? value
            self.value = adjustedValue
            slider.value = adjustedValue
            displayLabel?.text = displayTextFromValue?(adjustedValue) ?? "\(adjustedValue)"
            onValueChanged?(adjustedValue)
        }
    }
}