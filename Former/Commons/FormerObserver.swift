//
//  FormerObserver.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerObserver: NSObject {
    
    private weak var observedRowFormer: RowFormer?
    private weak var observedObject: NSObject?
    private var targetComponents: [(Selector, UIControlEvents)]?
    
    override init() {
        super.init()
    }
    
    convenience init(inout rowFormer: RowFormer) {
        
        self.init()
        self.observedRowFormer = rowFormer
    }
    
    deinit {
        self.removeSuitableObserver()
    }
    
    public func setObservedFormer(rowFormer: RowFormer) {
        self.removeSuitableObserver()
        self.observedRowFormer = rowFormer
        self.addSuitableObserver()
    }
    
    public func removeSuitableObserver() {
        
        if case let (object?, components?) = (self.observedObject, self.targetComponents) {
            components.map {
                (object as! UIControl).removeTarget(object, action: $0.0, forControlEvents: $0.1)
            }
        }
        self.observedRowFormer = nil
        self.observedObject = nil
        self.targetComponents = nil
    }
    
    private func addSuitableObserver() {
        
        guard let rowFormer = self.observedRowFormer else { return }

        switch rowFormer {
            
        case let rowFormer as TextFieldRowFormer:
            guard let cell = rowFormer.cell as? TextFieldFormableRow else { break }
            self.observedObject = cell.formerTextField()
            self.targetComponents = [
                ("didChangeText", .EditingChanged),
                ("editingDidBegin", .EditingDidBegin),
                ("editingDidEnd", .EditingDidEnd)
            ]
        case let rowFormer as TextViewRowFormer:
            guard let cell = rowFormer.cell as? TextViewFormableRow else { break }
            let textView = cell.formerTextView()
            textView.delegate = self
            self.observedObject = textView
        case let rowFormer as SwitchRowFormer:
            guard let cell = rowFormer.cell as? SwitchFormableRow else { break }
            self.observedObject = cell.formerSwitch()
            self.targetComponents = [("didChangeSwitch", .ValueChanged)]
        case let rowFormer as StepperRowFormer:
            guard let cell = rowFormer.cell as? StepperFormableRow else { break }
            self.observedObject = cell.formerStepper()
            self.targetComponents = [("didChangeValue", .ValueChanged)]
        case let rowFormer as SegmentedRowFormer:
            guard let cell = rowFormer.cell as? SegmentedFormableRow else { break }
            self.observedObject = cell.formerSegmented()
            self.targetComponents = [("didChangeValue", .ValueChanged)]
        case let rowFormer as SliderRowFormer:
            guard let cell = rowFormer.cell as? SliderFormableRow else { break }
            self.observedObject = cell.formerSlider()
            self.targetComponents = [("didChangeValue", .ValueChanged)]
        case let rowFormer as DatePickerRowFormer:
            guard let cell = rowFormer.cell as? DatePickerFormableRow else { break }
            self.observedObject = cell.formerDatePicker()
            self.targetComponents = [("didChangeDate", .ValueChanged)]
        default: break
        }

        self.targetComponents?.map {
            (self.observedObject as? UIControl)?.addTarget(rowFormer, action: $0.0, forControlEvents: $0.1)
        }
    }
}

extension FormerObserver: UITextViewDelegate {
    
    public func textViewDidChange(textView: UITextView) {
        (self.observedRowFormer as! TextViewRowFormer).didChangeText()
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        (self.observedRowFormer as! TextViewRowFormer).editingDidBegin()
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        (self.observedRowFormer as! TextViewRowFormer).editingDidEnd()
    }
}