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

public class StepperRowFormer<T: UITableViewCell where T: StepperFormableRow>
: CustomRowFormer<T>, FormerValidatable {
    
    // MARK: Public
    
    public var onValidate: (Double -> Bool)?
    
    public var onValueChanged: (Double -> Void)?
    public var displayTextFromValue: (Double -> String?)?
    public var value: Double = 0
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var displayDisabledColor: UIColor? = .lightGrayColor()
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    deinit {
        typedCell.formStepper().removeTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
    }
    
    public override func cellInitialized(cell: UITableViewCell) {
        super.cellInitialized(cell)
        if let row = cell as? StepperFormableRow {
            row.formStepper().addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        }
    }
    
    public override func update() {
        super.update()
        
        typedCell.selectionStyle = .None
        let titleLabel = typedCell.formTitleLabel()
        let displayLabel = typedCell.formDisplayLabel()
        let stepper = typedCell.formStepper()
        stepper.value = value
        stepper.enabled = enabled
        displayLabel?.text = displayTextFromValue?(value) ?? "\(value)"
        
        if enabled {
            titleLabel?.textColor =? titleColor
            displayLabel?.textColor =? displayColor
            stepper.tintColor =? stepperTintColor
            titleColor = nil
            displayColor = nil
            stepperTintColor = nil
        } else {
            titleColor ?= titleLabel?.textColor
            displayColor ?= displayLabel?.textColor
            stepperTintColor ?= stepper.tintColor
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
            stepper.tintColor = stepperTintColor?.colorWithAlphaComponent(0.5)
        }
    }
    
    public func validate() -> Bool {
        return onValidate?(value) ?? true
    }
    
    // MARK: Private
    
    private var titleColor: UIColor?
    private var displayColor: UIColor?
    private var stepperTintColor: UIColor?
    
    private dynamic func valueChanged(stepper: UIStepper) {
        let value = stepper.value
        self.value = value
        typedCell.formDisplayLabel()?.text = displayTextFromValue?(value) ?? "\(value)"
        onValueChanged?(value)
    }
}