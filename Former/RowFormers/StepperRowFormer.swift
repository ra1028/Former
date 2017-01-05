//
//  StepperRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol StepperFormableRow: FormableRow {
    
    func formStepper() -> UIStepper
    func formTitleLabel() -> UILabel?
    func formDisplayLabel() -> UILabel?
}

open class StepperRowFormer<T: UITableViewCell>
: BaseRowFormer<T>, Formable where T: StepperFormableRow {
    
    // MARK: Public
    
    open var value: Double = 0
    open var titleDisabledColor: UIColor? = .lightGray
    open var displayDisabledColor: UIColor? = .lightGray
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    @discardableResult
    public final func onValueChanged(_ handler: @escaping ((Double) -> Void)) -> Self {
        onValueChanged = handler
        return self
    }
    
    @discardableResult
    public final func displayTextFromValue(_ handler: @escaping ((Double) -> String?)) -> Self {
        displayTextFromValue = handler
        return self
    }
    
    open override func cellInitialized(_ cell: T) {
        super.cellInitialized(cell)
        cell.formStepper().addTarget(self, action: #selector(StepperRowFormer.valueChanged(stepper:)), for: .valueChanged)
    }
    
    open override func update() {
        super.update()
        
        cell.selectionStyle = .none
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        let stepper = cell.formStepper()
        stepper.value = value
        stepper.isEnabled = enabled
        displayLabel?.text = displayTextFromValue?(value) ?? "\(value)"
        
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            _ = displayColor.map { displayLabel?.textColor = $0 }
            _ = stepperTintColor.map { stepper.tintColor = $0 }
            titleColor = nil
            displayColor = nil
            stepperTintColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayColor == nil { displayColor = displayLabel?.textColor ?? .black }
            if stepperTintColor == nil { stepperTintColor = stepper.tintColor }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
            stepper.tintColor = stepperTintColor?.withAlphaComponent(0.5)
        }
    }
    
    // MARK: Private
    
    private final var onValueChanged: ((Double) -> Void)?
    private final var displayTextFromValue: ((Double) -> String?)?
    private final var titleColor: UIColor?
    private final var displayColor: UIColor?
    private final var stepperTintColor: UIColor?
    
    private dynamic func valueChanged(stepper: UIStepper) {
        let value = stepper.value
        self.value = value
        cell.formDisplayLabel()?.text = displayTextFromValue?(value) ?? "\(value)"
        onValueChanged?(value)
    }
}
