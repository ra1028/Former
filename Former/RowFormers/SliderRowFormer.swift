//
//  SliderRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SliderFormableRow: FormableRow {
    
    func formerSlider() -> UISlider
    func formerTitleLabel() -> UILabel?
    func formerDisplayLabel() -> UILabel?
}

public class SliderRowFormer: RowFormer {
    
    private let observer = FormerObserver()
    
    public var sliderChangedHandler: (Float -> Void)?
    public var displayTextFromValue: (Float -> String)?
    public var adjustedValueFromValue: (Float -> Float)?
    public var value: Float = 0
    public var continuous: Bool?
    public var minimumValue: Float?
    public var maximumValue: Float?
    public var tintColor: UIColor?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    
    public var displayFont: UIFont?
    public var displayColor: UIColor?
    
    init<T : UITableViewCell where T : SliderFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        sliderChangedHandler: (Float -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.sliderChangedHandler = sliderChangedHandler
            self.selectionStyle = UITableViewCellSelectionStyle.None
            self.cellHeight = 88.0
    }
    
    public override func cellConfigure(cell: UITableViewCell) {
        
        super.cellConfigure(cell)
        
        self.observer.setObservedFormer(self)
        
        if let row = self.cell as? SliderFormableRow {
            
            let slider = row.formerSlider()
            slider.value = self.adjustedValueFromValue?(self.value) ?? self.value
            slider.continuous =? self.continuous
            slider.minimumValue =? self.minimumValue
            slider.maximumValue =? self.maximumValue
            slider.tintColor =? self.tintColor
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text =? self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor =? self.titleColor
            
            let displayLabel = row.formerDisplayLabel()
            displayLabel?.text = self.displayTextFromValue?(self.value) ?? "\(self.value)"
            displayLabel?.font =? self.displayFont
            displayLabel?.textColor =? self.displayColor
        }
    }
    
    public dynamic func didChangeValue() {
        
        if let cell = self.cell as? SliderFormableRow {
            let slider = cell.formerSlider()
            let displayLabel = cell.formerDisplayLabel()
            
            let value = slider.value
            let adjustedValue = self.adjustedValueFromValue?(value) ?? value
            self.value = adjustedValue
            slider.value = adjustedValue
            displayLabel?.text = self.displayTextFromValue?(adjustedValue) ?? "\(adjustedValue)"
            self.sliderChangedHandler?(adjustedValue)
        }
    }
}