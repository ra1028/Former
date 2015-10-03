//
//  StepperRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol StepperFormableRow: FormableRow {
    
    var observer: FormerObserver { get }
    
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
    
    public override func update() {
        super.update()
        
        cell.selectionStyle = .None
        if let row = cell as? StepperFormableRow {
            let titleLabel = row.formTitleLabel()
            let displayLabel = row.formDisplayLabel()
            let stepper = row.formStepper()
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
            
            row.observer.setTargetRowFormer(self,
                control: stepper,
                actionEvents: [("valueChanged:", .ValueChanged)]
            )
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
        if let row = cell as? StepperFormableRow where enabled {
            let value = stepper.value
            self.value = value
            row.formDisplayLabel()?.text = displayTextFromValue?(value) ?? "\(value)"
            onValueChanged?(value)
        }
    }
}