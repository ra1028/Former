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
: BaseRowFormer<T>, Formable {
    
    // MARK: Public
    
    public var value: Double = 0
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var displayDisabledColor: UIColor? = .lightGrayColor()
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public final func onValueChanged(handler: (Double -> Void)) -> Self {
        onValueChanged = handler
        return self
    }
    
    public final func displayTextFromValue(handler: (Double -> String?)) -> Self {
        displayTextFromValue = handler
        return self
    }
    
    public override func cellInitialized(cell: T) {
        super.cellInitialized(cell)
        cell.formStepper().addTarget(self, action: #selector(StepperRowFormer.valueChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    public override func update() {
        super.update()
        
        cell.selectionStyle = .None
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        let stepper = cell.formStepper()
        stepper.value = value
        stepper.enabled = enabled
        displayLabel?.text = displayTextFromValue?(value) ?? "\(value)"
        
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            _ = displayColor.map { displayLabel?.textColor = $0 }
            _ = stepperTintColor.map { stepper.tintColor = $0 }
            titleColor = nil
            displayColor = nil
            stepperTintColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .blackColor() }
            if displayColor == nil { displayColor = displayLabel?.textColor ?? .blackColor() }
            if stepperTintColor == nil { stepperTintColor = stepper.tintColor }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
            stepper.tintColor = stepperTintColor?.colorWithAlphaComponent(0.5)
        }
    }
    
    // MARK: Private
    
    private final var onValueChanged: (Double -> Void)?
    private final var displayTextFromValue: (Double -> String?)?
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