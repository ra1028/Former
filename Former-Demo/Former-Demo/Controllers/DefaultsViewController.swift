//
//  DefaultsViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class DefaultsViewController: FormViewController {
    
    // MARK: Public

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: Private
    
    private var enabled = true
    
    private func configure() {
        title = "Default UI"
        
        // Create RowFomers
        
        let disableRowText: (Bool -> String) = {
            return ($0 ? "Enable" : "Disable") + " All Cells"
        }
        let disableRow = LabelRowFormer<FormLabelCell>()
            .configure {
                $0.text = disableRowText(false)
            }.onSelected(disableRowSelected)
        
        let labelRow = LabelRowFormer<FormLabelCell>()
            .configure {
                $0.text = "Text"
                $0.subText = "SubText"
            }.onSelected { [weak self] _ in
                self?.former.deselect(true)
        }
        
        let textFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "TextField"
            }.configure {
                $0.placeholder = "Placeholder"
        }
        
        let textViewRow = TextViewRowFormer<FormTextViewCell> {
            $0.titleLabel.text = "TextView"
            }.configure {
                $0.placeholder = "Placeholder"
        }
        
        let checkRow = CheckRowFormer<FormCheckCell>{
            $0.titleLabel.text = "Check"
        }
        
        let switchRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Switch"
        }
        
        let stepperRow = StepperRowFormer<FormStepperCell>(){
            $0.titleLabel.text = "Stepper"
            }.displayTextFromValue { "\(Int($0))" }
        
        let segmentRow = SegmentedRowFormer<FormSegmentedCell>() {
            $0.titleLabel.text = "Segmented"
            }.configure {
                $0.segmentTitles = ["Opt1", "Opt2", "Opt3"]
                $0.selectedIndex = UISegmentedControlNoSegment
        }
        
        let sliderRow = SliderRowFormer<FormSliderCell>(){
            $0.titleLabel.text = "Slider"
            }.displayTextFromValue { "\(Float(round($0 * 10) / 10))" }
        
        let selectorPickerRow = SelectorPickerRowFormer<FormSelectorPickerCell, Any>() {
            $0.titleLabel.text = "SelectorPicker"
            }.configure {
                $0.pickerItems = [SelectorPickerItem(
                    title: "",
                    displayTitle: NSAttributedString(string: "Not Set"),
                    value: nil)]
                    + (1...20).map { SelectorPickerItem(title: "Option\($0)") }
        }
        
        let selectorDatePickerRow = SelectorDatePickerRowFormer<FormSelectorDatePickerCell> {
            $0.titleLabel.text = "SelectorDatePicker"
            }.displayTextFromDate(String.mediumDateShortTime)
        
        let inlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Any>() {
            $0.titleLabel.text = "InlinePicker"
            }.configure {
                $0.pickerItems = [InlinePickerItem(
                    title: "",
                    displayTitle: NSAttributedString(string: "Not set"),
                    value: nil)]
                    + (1...20).map { InlinePickerItem(title: "Option\($0)") }
        }
        
        let inlineDateRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "InlineDatePicker"
            }.displayTextFromDate(String.mediumDateShortTime)
        
        let pickerRow = PickerRowFormer<FormPickerCell, Any>()
            .configure {
                $0.pickerItems = (1...20).map { PickerItem(title: "Option\($0)") }
        }
        
        let datePickerRow = DatePickerRowFormer<FormDatePickerCell>()
        
        // Create SectionFormers
        
        let sectionFormer1 = SectionFormer(rowFormer: disableRow)
        
        let sectionFormer2 = SectionFormer(rowFormer:
            labelRow, textFieldRow, textViewRow,
            checkRow, switchRow, stepperRow,
            segmentRow, sliderRow, selectorPickerRow,
            selectorDatePickerRow, inlinePickerRow, inlineDateRow
        )
        
        let sectionFormer3 = SectionFormer(rowFormer: pickerRow, datePickerRow)
            .set(footerViewFormer: CustomViewFormer<FormHeaderFooterView>())
        
        former.append(sectionFormer: sectionFormer1, sectionFormer2, sectionFormer3)
    }
    
    private func disableRowSelected(rowFormer: RowFormer) {
        guard let disableRow = rowFormer as? LabelRowFormer<FormLabelCell> else { return }
        self.former.deselect(true)
        self.former[1...2].flatMap { $0.rowFormers }.forEach {
            $0.enabled = !enabled
        }
        disableRow.text = (enabled ? "Enable" : "Disable") + " All Cells"
        disableRow.update()
        self.enabled = !self.enabled
    }
}