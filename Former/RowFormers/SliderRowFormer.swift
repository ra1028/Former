//
//  SliderRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SliderFormableRow: FormableRow {
        
    func formSlider() -> UISlider
    func formTitleLabel() -> UILabel?
    func formDisplayLabel() -> UILabel?
}

open class SliderRowFormer<T: UITableViewCell>
: BaseRowFormer<T>, Formable where T: SliderFormableRow {
    
    // MARK: Public
    
    open var value: Float = 0
    open var titleDisabledColor: UIColor? = .lightGray
    open var displayDisabledColor: UIColor? = .lightGray
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    open override func initialized() {
        super.initialized()
        rowHeight = 88
    }
    
    @discardableResult
    public final func onValueChanged(_ handler: @escaping ((Float) -> Void)) -> Self {
        onValueChanged = handler
        return self
    }
    
    @discardableResult
    public final func displayTextFromValue(_ handler: @escaping ((Float) -> String)) -> Self {
        displayTextFromValue = handler
        return self
    }
    
    @discardableResult
    public final func adjustedValueFromValue(_ handler: @escaping ((Float) -> Float)) -> Self {
        adjustedValueFromValue = handler
        return self
    }
    
    open override func cellInitialized(_ cell: T) {
        super.cellInitialized(cell)
        cell.formSlider().addTarget(self, action: #selector(SliderRowFormer.valueChanged(slider:)), for: .valueChanged)
    }
    
    open override func update() {
        super.update()
        
        cell.selectionStyle = .none
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        let slider = cell.formSlider()
        slider.value = adjustedValueFromValue?(value) ?? value
        slider.isEnabled = enabled
        displayLabel?.text = displayTextFromValue?(value) ?? "\(value)"
        
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            _ = displayColor.map { displayLabel?.textColor = $0 }
            titleColor = nil
            displayColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayColor == nil { displayColor = displayLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
    }
    
    // MARK: Private
    
    private final var onValueChanged: ((Float) -> Void)?
    private final var displayTextFromValue: ((Float) -> String)?
    private final var adjustedValueFromValue: ((Float) -> Float)?
    private final var titleColor: UIColor?
    private final var displayColor: UIColor?
    
    private dynamic func valueChanged(slider: UISlider) {
        let displayLabel = cell.formDisplayLabel()
        let value = slider.value
        let adjustedValue = adjustedValueFromValue?(value) ?? value
        self.value = adjustedValue
        slider.value = adjustedValue
        displayLabel?.text = displayTextFromValue?(adjustedValue) ?? "\(adjustedValue)"
        onValueChanged?(adjustedValue)
    }
}
