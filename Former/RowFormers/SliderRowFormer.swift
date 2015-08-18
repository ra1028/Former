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

public class SliderRowFormer: RowFormer {
    
    public var onValueChanged: (Float -> Void)?
    public var displayTextFromValue: (Float -> String)?
    public var adjustedValueFromValue: (Float -> Float)?
    public var value: Float = 0
    public var continuous: Bool?
    public var minimumValue: Float?
    public var maximumValue: Float?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    
    public var displayFont: UIFont?
    public var displayColor: UIColor?
    public var displayDisabledColor: UIColor?
    
    init<T : UITableViewCell where T : SliderFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        onValueChanged: (Float -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.onValueChanged = onValueChanged
    }
    
    public override func initializeRowFomer() {
        
        super.initializeRowFomer()
        self.titleDisabledColor = .lightGrayColor()
        self.displayColor = .lightGrayColor()
        self.displayDisabledColor = .lightGrayColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.cellHeight = 88.0
    }
    
    public override func update() {
        
        super.update()
        
        if let row = self.cell as? SliderFormableRow {
            
            let slider = row.formerSlider()
            slider.value = self.adjustedValueFromValue?(self.value) ?? self.value
            slider.continuous =? self.continuous
            slider.minimumValue =? self.minimumValue
            slider.maximumValue =? self.maximumValue
            slider.tintColor =? self.tintColor
            slider.enabled = self.enabled
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            
            let displayLabel = row.formerDisplayLabel()
            displayLabel?.text = self.displayTextFromValue?(self.value) ?? "\(self.value)"
            displayLabel?.font =? self.displayFont
            displayLabel?.textColor = self.enabled ? self.displayColor : self.displayDisabledColor
            
            row.observer.setTargetRowFormer(self,
                control: slider,
                actionEvents: [("valueChanged:", .ValueChanged)]
            )
        }
    }
    
    public func valueChanged(slider: UISlider) {
        
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