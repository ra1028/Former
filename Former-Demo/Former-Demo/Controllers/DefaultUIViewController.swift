//
//  DemoViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class DefaultUIViewController: FormerViewController {
    
    private var enabled = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    private func configure() {
        title = "Default UI"
        
        // Create RowFomers
        
        let disableRow = TextRowFormer(
            cellType: FormerTextCell.self,
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
            cellType: FormerTextCell.self,
            instantiateType: .Class
        )
        textRow.onSelected = { [weak self] _ in self?.former.deselect(true) }
        textRow.text = "Text"
        textRow.subText = "SubText"
        
        let textFieldRow = TextFieldRowFormer(
            cellType: FormerTextFieldCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "TextField"
        }
        textFieldRow.placeholder = "Placeholder"
        
        let textViewRow = TextViewRowFormer(
            cellType: FormerTextViewCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "TextView"
        }
        textViewRow.placeholder = "Placeholder"
        
        let checkRow = CheckRowFormer(
            cellType: FormerCheckCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "Check"
        }
        
        let switchRow = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "Switch"
        }
        
        let stepperRow = StepperRowFormer(
            cellType: FormerStepperCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "Stepper"
        }
        stepperRow.displayTextFromValue = { "\(Int($0))" }
        
        let segmentRow = SegmentedRowFormer(
            cellType: FormerSegmentedCell.self,
            instantiateType: .Class,
            segmentTitles: ["Opt1", "Opt2", "Opt3"]
            ) {
                $0.titleLabel.text = "Segmented"
        }
        
        let sliderRow = SliderRowFormer(
            cellType: FormerSliderCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "Slider"
        }
        sliderRow.displayTextFromValue = { "\(Float(round($0 * 10) / 10))" }
        
        let selectorPickerRow = SelectorPickerRowFormer(
            cellType: FormerSelectorPickerCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "SelectorPicker"
        }
        selectorPickerRow.valueTitles = (1...20).map { "Option\($0)" }
        
        let selectorDatePickerRow = SelectorDatePickerRowFormer(
            cellType: FormerSelectorDatePickerCell.self,
            instantiateType: .Class
            ) {
                $0.titleLabel.text = "SelectorDatePicker"
        }
        selectorDatePickerRow.displayTextFromDate = String.mediumDateShortTime
        
        let inlinePickerRow = InlinePickerRowFormer(
            cellType: FormerInlinePickerCell.self,
            instantiateType: .Class,
            cellConfiguration: {
                $0.titleLabel.text = "InlinePicker"
        })
        inlinePickerRow.valueTitles = (1...20).map { "Option\($0)" }
        
        let inlineDateRow = InlineDatePickerRowFormer(
            cellType: FormerInlineDatePickerCell.self,
            instantiateType: .Class,
            cellConfiguration: {
                $0.titleLabel.text = "InlineDatePicker"
            })
        inlineDateRow.displayTextFromDate = String.mediumDateShortTime
        
        let pickerRow = PickerRowFormer(
            cellType: FormerPickerCell.self,
            instantiateType: .Class
        )
        pickerRow.valueTitles = (1...20).map { "Option\($0)" }
        
        let datePickerRow = DatePickerRowFormer(
            cellType: FormerDatePickerCell.self,
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
            .set(footerViewFormer: ViewFormer(viewType: FormerHeaderFooterView.self, instantiateType: .Class))
        
        former.add(sectionFormers: [sectionFormer1, sectionFormer2, sectionFormer3])
    }
}