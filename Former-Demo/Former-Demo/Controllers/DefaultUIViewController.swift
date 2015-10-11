//
//  DemoViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class DefaultUIViewController: FormViewController {
    
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
        
        let disableRow = TextRowFormer<FormTextCell>()
        let disableRowText: (Bool -> String) = {
            return ($0 ? "Enable" : "Disable") + " All Cells"
        }
        disableRow.text = disableRowText(false)
        disableRow.onSelected = disableRowSelected
        
        let textRow = TextRowFormer<FormTextCell>()
        textRow.text = "Text"
        textRow.subText = "SubText"
        textRow.onSelected = { [weak self] _ in self?.former.deselect(true) }
        
        let textFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "TextField"
        }
        textFieldRow.placeholder = "Placeholder"
        
        let textViewRow = TextViewRowFormer<FormTextViewCell> {
            $0.titleLabel.text = "TextView"
        }
        textViewRow.placeholder = "Placeholder"
        
        let checkRow = CheckRowFormer<FormCheckCell>{
            $0.titleLabel.text = "Check"
        }
        
        let switchRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Switch"
        }
        
        let stepperRow = StepperRowFormer<FormStepperCell>(){
            $0.titleLabel.text = "Stepper"
        }
        stepperRow.displayTextFromValue = { "\(Int($0))" }
        
        let segmentRow = SegmentedRowFormer<FormSegmentedCell>() {
            $0.titleLabel.text = "Segmented"
        }
        segmentRow.segmentTitles = ["Opt1", "Opt2", "Opt3"]
        
        let sliderRow = SliderRowFormer<FormSliderCell>(){
            $0.titleLabel.text = "Slider"
        }
        sliderRow.displayTextFromValue = { "\(Float(round($0 * 10) / 10))" }
        
        let selectorPickerRow = SelectorPickerRowFormer<FormSelectorPickerCell, Any>() {
            $0.titleLabel.text = "SelectorPicker"
        }
        selectorPickerRow.pickerItems = [SelectorPickerItem<Any>(
            title: "",
            displayTitle: NSAttributedString(string: "Not set", attributes: [NSForegroundColorAttributeName : UIColor.redColor()]),
            value: nil)]
            + (1...20).map { SelectorPickerItem<Any>(title: "Option\($0)") }
        selectorPickerRow.displayEditingColor = UIColor.blueColor()
        
        let selectorDatePickerRow = SelectorDatePickerRowFormer<FormSelectorDatePickerCell> {
            $0.titleLabel.text = "SelectorDatePicker"
        }
        selectorDatePickerRow.displayTextFromDate = String.mediumDateShortTime
        
        let inlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Any>() {
            $0.titleLabel.text = "InlinePicker"
        }
        inlinePickerRow.pickerItems = [InlinePickerItem<Any>(
            title: "",
            displayTitle: NSAttributedString(string: "Not set", attributes: [NSForegroundColorAttributeName : UIColor.redColor()]),
            value: nil)]
            + (1...20).map { InlinePickerItem<Any>(title: "Option\($0)") }
        
        let inlineDateRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "InlineDatePicker"
        }
        inlineDateRow.displayTextFromDate = String.mediumDateShortTime
        
        let pickerRow = PickerRowFormer<FormPickerCell, Any>()
        pickerRow.pickerItems = (1...20).map { PickerItem<Any>(title: "Option\($0)") }
        
        let datePickerRow = DatePickerRowFormer<FormDatePickerCell>()
        
        // Create SectionFormers
        
        let sectionFormer1 = SectionFormer(rowFormers: [disableRow])
        
        let sectionFormer2 = SectionFormer(rowFormers: [
            textRow, textFieldRow, textViewRow,
            checkRow, switchRow, stepperRow,
            segmentRow, sliderRow, selectorPickerRow,
            selectorDatePickerRow, inlinePickerRow, inlineDateRow
            ])
        
        let sectionFormer3 = SectionFormer(rowFormers: [pickerRow, datePickerRow])
            .set(footerViewFormer: CustomViewFormer<FormHeaderFooterView>())
        
        former.add(sectionFormers: [sectionFormer1, sectionFormer2, sectionFormer3])
    }
    
    private func disableRowSelected(indexPath: NSIndexPath, rowFormer: RowFormer) {
        guard let disableRow = rowFormer as? TextRowFormer<FormTextCell> else { return }
        self.former.deselect(true)
        self.former[1...2].flatMap { $0.rowFormers }.forEach {
            $0.enabled = !enabled
        }
        disableRow.text = (enabled ? "Enable" : "Disable") + " All Cells"
        disableRow.update()
        self.enabled = !self.enabled
    }
}