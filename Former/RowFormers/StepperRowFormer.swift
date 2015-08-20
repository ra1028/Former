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

public class StepperRowFormer: RowFormer {
    
    public var onValueChanged: (Double -> Void)?
    public var displayTextFromValue: (Double -> String?)?
    public var value: Double = 0
    public var continuous: Bool?
    public var autorepeat: Bool?
    public var wraps: Bool?
    public var minimumValue: Double?
    public var maximumValue: Double?
    public var stepValue: Double?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    
    public var displayFont: UIFont?
    public var displayColor: UIColor?
    public var displayDisabledColor: UIColor?
    
    public init<T : UITableViewCell where T : StepperFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        onValueChanged: (Double -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.onValueChanged = onValueChanged
    }
    
    public override func initializeRowFomer() {
        
        super.initializeRowFomer()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.titleDisabledColor = .lightGrayColor()
        self.displayColor = .lightGrayColor()
        self.displayDisabledColor = .lightGrayColor()
    }
    
    public override func update() {
        
        super.update()
        
        if let row = self.cell as? StepperFormableRow {
            
            let stepper = row.formerStepper()
            stepper.value = self.value
            stepper.continuous =? self.continuous
            stepper.autorepeat =? self.autorepeat
            stepper.wraps =? self.wraps
            stepper.minimumValue =? self.minimumValue
            stepper.maximumValue =? self.maximumValue
            stepper.stepValue =? self.stepValue
            stepper.enabled = self.enabled
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            
            let displayLabel = row.formerDisplayLabel()
            displayLabel?.text = self.displayTextFromValue?(value) ?? "\(value)"
            displayLabel?.font =? self.displayFont
            displayLabel?.textColor = self.enabled ? self.displayColor : self.displayDisabledColor
            
            row.observer.setTargetRowFormer(self,
                control: stepper,
                actionEvents: [("valueChanged:", .ValueChanged)]
            )
        }
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