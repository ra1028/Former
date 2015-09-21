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
    
    func formerStepper() -> UIStepper
    func formerTitleLabel() -> UILabel?
    func formerDisplayLabel() -> UILabel?
}

public class StepperRowFormer: RowFormer, FormerValidatable {
    
    public var onValidate: (Double -> Bool)?
    
    public var onValueChanged: (Double -> Void)?
    public var displayTextFromValue: (Double -> String?)?
    public var value: Double = 0
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var displayDisabledColor: UIColor? = .lightGrayColor()
    
    private var titleColor: UIColor?
    private var displayColor: UIColor?
    
    public init<T : UITableViewCell where T : StepperFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        onValueChanged: (Double -> Void)? = nil,
        cellConfiguration: (T -> Void)? = nil) {
            
            super.init(cellType: cellType, instantiateType: instantiateType, cellConfiguration: cellConfiguration)
            self.onValueChanged = onValueChanged
    }
    
    public override func update() {
        
        super.update()
        
        self.cell?.selectionStyle = .None
        
        if let row = self.cell as? StepperFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            let displayLabel = row.formerDisplayLabel()
            let stepper = row.formerStepper()
            
            stepper.value = self.value
            stepper.enabled = self.enabled
            displayLabel?.text = self.displayTextFromValue?(value) ?? "\(value)"
            
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
                control: stepper,
                actionEvents: [("valueChanged:", .ValueChanged)]
            )
        }
    }
    
    public func validate() -> Bool {
        
        return self.onValidate?(self.value) ?? true
    }
    
    public dynamic func valueChanged(stepper: UIStepper) {
        
        if let row = self.cell as? StepperFormableRow where self.enabled {
            let value = stepper.value
            self.value = value
            row.formerDisplayLabel()?.text = self.displayTextFromValue?(value) ?? "\(value)"
            self.onValueChanged?(value)
        }
    }
}