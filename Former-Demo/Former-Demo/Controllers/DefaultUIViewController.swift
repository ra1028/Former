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
        
        self.title = "DefaultUI"
        
        // Create RowFomers
        
        let rowFormer1 = TextRowFormer(
            cellType: FormerTextCell.self,
            registerType: .Class,
            selectedHandler: { [weak self] indexPath in
                self?.former.deselect(true)
            }
        )
        rowFormer1.text = "Text"
        rowFormer1.subText = "SubText"
        
        let rowFormer2 = TextFieldRowFormer(
            cellType: FormerTextFieldCell.self,
            registerType: .Class
        )
        rowFormer2.title = "TextField"
        rowFormer2.placeholder = "Example"
        
        let rowFormer3 = CheckRowFormer(
            cellType: FormerCheckCell.self,
            registerType: .Class
        )
        rowFormer3.title = "Check"
        
        let rowFormer4 = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            registerType: .Class
        )
        rowFormer4.title = "Switch"
        
        let rowFormer5 = StepperRowFormer(
            cellType: FormerStepperCell.self,
            registerType: .Class
        )
        rowFormer5.title = "Stepper"
        rowFormer5.displayTextFromValue = { "\(Int($0))" }
        
        let rowFormer6 = SegmentedRowFormer(
            cellType: FormerSegmentedCell.self,
            registerType: .Class,
            segmentTitles: ["  A  ", "  B  ", "  C  "]
        )
        rowFormer6.title = "Segmented"
        
        let rowFormer7 = SliderRowFormer(
            cellType: FormerSliderCell.self,
            registerType: .Class
        )
        rowFormer7.title = "Slider"
        rowFormer7.adjustedValueFromValue = { Float(round($0 * 10) / 10) }
        rowFormer7.displayTextFromValue = { "\($0)" }
        
        let rowFormer8 = InlinePickerRowFormer(
            cellType: FormerInlinePickerCell.self,
            registerType: .Class
        )
        rowFormer8.title = "InlinePicker"
        rowFormer8.valueTitles = ["A", "B", "C", "D", "E"]
        
        let rowFormer9 = InlineDatePickerRowFormer(
            cellType: FormerInlineDatePickerCell.self,
            registerType: .Class
        )
        rowFormer9.title = "InlineDatePicker"
        rowFormer9.datePickerMode = .Date
        rowFormer9.displayTextFromDate = String.fullDate
        
        let rowFormer10 = TextViewRowFormer(
            cellType: FormerTextViewCell.self,
            registerType: .Class
        )
        rowFormer10.title = "TextView"
        rowFormer10.placeholder = "Example"
        
        let rowFormer11 = TextRowFormer(
            cellType: FormerTextCell.self,
            registerType: .Class
        )
        rowFormer11.selectedHandler = { [weak self, weak rowFormer11] _ in
            if let sSelf = self {
                sSelf.former.deselect(true)
                rowFormer11?.text = sSelf.enabled ? "Enable" : "Disable"
                sSelf.former[0].rowFormers.forEach {
                    $0.enabled = !sSelf.enabled
                    $0.update()
                }
                rowFormer11?.update()
                sSelf.enabled = !sSelf.enabled
            }
        }
        rowFormer11.text = "Disable"
        
        // Create SectionFormers
        
        let sectionFormer1 = SectionFormer()
            .add(rowFormers: [
                rowFormer1, rowFormer2, rowFormer3,
                rowFormer4, rowFormer5, rowFormer6,
                rowFormer7, rowFormer8, rowFormer9,
                rowFormer10
                ])
        
        let sectionFormer2 = SectionFormer()
            .add(rowFormers: [rowFormer11])
            .set(footerViewFormer: ViewFormer(viewType: FormerHeaderFooterView.self, registerType: .Class))
        
        self.former.add(sectionFormers: [sectionFormer1, sectionFormer2])
    }
}