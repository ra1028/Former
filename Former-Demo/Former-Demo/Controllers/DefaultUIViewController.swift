//
//  DemoViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

class DefaultUIViewController: FormerViewController {
    
    private var enabled = true

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configure()
        
    }
    
    private func configure() {
        
        self.title = "Default UI"
        
        // Create RowFomers
        
        let disableRow = TextRowFormer(
            cellType: FormerTextCell.self,
            registerType: .Class
        )
        let disableRowText: (Bool -> String) = {
            return ($0 ? "Enable" : "Disable") + " All Cells"
        }
        disableRow.onSelected = { [weak self] in
            if case let (sSelf?, disableRow?) = (self, $1 as? TextRowFormer) {
                sSelf.former.deselect(true)
                sSelf.former[1...2].flatMap { $0.rowFormers }.forEach {
                    $0.enabled = !sSelf.enabled
                    $0.update()
                }
                disableRow.text = disableRowText(sSelf.enabled)
                disableRow.update()
                sSelf.enabled = !sSelf.enabled
            }
        }
        disableRow.text = disableRowText(false)
        
        let textRow = TextRowFormer(
            cellType: FormerTextCell.self,
            registerType: .Class
        )
        textRow.onSelected = { [weak self] _ in
            self?.former.deselect(true)
        }
        textRow.text = "Text"
        textRow.subText = "SubText"
        
        let textFieldRow = TextFieldRowFormer(
            cellType: FormerTextFieldCell.self,
            registerType: .Class
        )
        textFieldRow.title = "TextField"
        textFieldRow.placeholder = "Placeholder"
        
        let textViewRow = TextViewRowFormer(
            cellType: FormerTextViewCell.self,
            registerType: .Class
        )
        textViewRow.title = "TextView"
        textViewRow.placeholder = "Placeholder"
        
        let checkRow = CheckRowFormer(
            cellType: FormerCheckCell.self,
            registerType: .Class
        )
        checkRow.title = "Check"
        
        let switchRow = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            registerType: .Class
        )
        switchRow.title = "Switch"
        
        let stepperRow = StepperRowFormer(
            cellType: FormerStepperCell.self,
            registerType: .Class
        )
        stepperRow.title = "Stepper"
        stepperRow.displayTextFromValue = { "\(Int($0))" }
        
        let segmentRow = SegmentedRowFormer(
            cellType: FormerSegmentedCell.self,
            registerType: .Class,
            segmentTitles: ["Apple", "Banana", "Cherry"]
        )
        segmentRow.title = "Segmented"
        
        let sliderRow = SliderRowFormer(
            cellType: FormerSliderCell.self,
            registerType: .Class
        )
        sliderRow.title = "Slider"
        sliderRow.displayTextFromValue = { "\(Float(round($0 * 10) / 10))" }
        
        let selectorPickerRow = SelectorPickerRowFormer(
            cellType: FormerSelectorPickerCell.self,
            registerType: .Class
        )
        selectorPickerRow.title = "SelectorPicker"
        selectorPickerRow.valueTitles = (1...20).map { "Option\($0)" }
        
        let inlinePickerRow = InlinePickerRowFormer(
            cellType: FormerInlinePickerCell.self,
            registerType: .Class
        )
        inlinePickerRow.title = "InlinePicker"
        inlinePickerRow.valueTitles = (1...20).map { "Option\($0)" }
        
        let inlineDateRow = InlineDatePickerRowFormer(
            cellType: FormerInlineDatePickerCell.self,
            registerType: .Class
        )
        inlineDateRow.title = "InlineDatePicker"
        inlineDateRow.datePickerMode = .Date
        inlineDateRow.displayTextFromDate = String.fullDate
        
        let pickerRow = PickerRowFormer(
            cellType: FormerPickerCell.self,
            registerType: .Class
        )
        pickerRow.valueTitles = (1...20).map { "Option\($0)" }
        
        let datePickerRow = DatePickerRowFormer(
            cellType: FormerDatePickerCell.self,
            registerType: .Class
        )
        
        // Create SectionFormers
        
        let sectionFormer1 = SectionFormer()
            .add(rowFormers: [disableRow])
        
        let sectionFormer2 = SectionFormer()
            .add(rowFormers: [
                textRow, textFieldRow, textViewRow,
                checkRow, switchRow, stepperRow,
                segmentRow, sliderRow, selectorPickerRow,
                inlinePickerRow, inlineDateRow])
            
        let sectionFormer3 = SectionFormer()
            .add(rowFormers: [pickerRow, datePickerRow])
            .set(footerViewFormer: ViewFormer(
                viewType: FormerHeaderFooterView.self,
                registerType: .Class))
        
        self.former.add(sectionFormers: [sectionFormer1, sectionFormer2, sectionFormer3])
    }
}