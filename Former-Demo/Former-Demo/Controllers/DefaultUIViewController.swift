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
    
    private var enabled = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    private func configure() {
        title = "Default UI"
        
        // Create RowFomers
        
        let disableRow = TextRowFormer(
            cellType: FormTextCell.self,
            instantiateType: .Class
        )
        let disableRowText: (Bool -> String) = {
            return ($0 ? "Enable" : "Disable") + " All Cells"
        }
        disableRow.onSelected = { [weak self] in
            if case let (sSelf?, disableRow?) = (self, $1 as? TextRowFormer) {
                sSelf.former.deselect(true)
                sSelf.former[1...2].flatMap { $0.rowFormers }.forEach {
                    $0.enabled = !sSelf.enabled
                }
                disableRow.text = disableRowText(sSelf.enabled)
                disableRow.update()
                sSelf.enabled = !sSelf.enabled
            }
        }
        disableRow.text = disableRowText(false)
        
        let textRow = TextRowFormer(
            cellType: FormTextCell.self,
            instantiateType: .Class
        )
        textRow.onSelected = { [weak self] _ in self?.former.deselect(true) }
        textRow.text = "Text"
        textRow.subText = "SubText"
        
        let textFieldRow = TextFieldRowFormer(
            cellType: FormTextFieldCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "TextField"
        }
        textFieldRow.placeholder = "Placeholder"
        
        let textViewRow = TextViewRowFormer(
            cellType: FormTextViewCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "TextView"
        }
        textViewRow.placeholder = "Placeholder"
        
        let checkRow = CheckRowFormer(
            cellType: FormCheckCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "Check"
        }
        
        let switchRow = SwitchRowFormer(
            cellType: FormSwitchCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "Switch"
        }
        
        let stepperRow = StepperRowFormer(
            cellType: FormStepperCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "Stepper"
        }
        stepperRow.displayTextFromValue = { "\(Int($0))" }
        
        let segmentRow = SegmentedRowFormer(
            cellType: FormSegmentedCell.self,
            instantiateType: .Class,
            segmentTitles: ["Opt1", "Opt2", "Opt3"]
            ) {
                $0.titleLabel.text = "Segmented"
        }
        
        let sliderRow = SliderRowFormer(
            cellType: FormSliderCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "Slider"
        }
        sliderRow.displayTextFromValue = { "\(Float(round($0 * 10) / 10))" }
        
        let selectorPickerRow = SelectorPickerRowFormer(
            cellType: FormSelectorPickerCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "SelectorPicker"
        }
        selectorPickerRow.valueTitles = (1...20).map { "Option\($0)" }
        
        let selectorDatePickerRow = SelectorDatePickerRowFormer(
            cellType: FormSelectorDatePickerCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "SelectorDatePicker"
        }
        selectorDatePickerRow.displayTextFromDate = String.mediumDateShortTime
        
        let inlinePickerRow = InlinePickerRowFormer(
            cellType: FormInlinePickerCell.self,
            instantiateType: .Class,
            cellSetup: {
                $0.titleLabel.text = "InlinePicker"
        })
        inlinePickerRow.valueTitles = (1...20).map { "Option\($0)" }
        
        let inlineDateRow = InlineDatePickerRowFormer(
            cellType: FormInlineDatePickerCell.self,
            instantiateType: .Class,
            cellSetup: {
                $0.titleLabel.text = "InlineDatePicker"
            })
        inlineDateRow.displayTextFromDate = String.mediumDateShortTime
        
        let pickerRow = PickerRowFormer(
            cellType: FormPickerCell.self,
            instantiateType: .Class
        )
        pickerRow.valueTitles = (1...20).map { "Option\($0)" }
        
        let datePickerRow = DatePickerRowFormer(
            cellType: FormDatePickerCell.self,
            instantiateType: .Class
        )
        
        // Create SectionFormers
        
        let sectionFormer1 = SectionFormer()
            .add(rowFormers: [disableRow])
        
        let sectionFormer2 = SectionFormer()
            .add(rowFormers: [
                textRow, textFieldRow, textViewRow,
                checkRow, switchRow, stepperRow,
                segmentRow, sliderRow, selectorPickerRow,
                selectorDatePickerRow, inlinePickerRow, inlineDateRow
                ])
            
        let sectionFormer3 = SectionFormer()
            .add(rowFormers: [pickerRow, datePickerRow])
            .set(footerViewFormer: ViewFormer(viewType: FormHeaderFooterView.self, instantiateType: .Class))
        
        former.add(sectionFormers: [sectionFormer1, sectionFormer2, sectionFormer3])
    }
}