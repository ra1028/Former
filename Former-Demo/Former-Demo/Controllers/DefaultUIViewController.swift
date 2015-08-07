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
                self?.former.deselectSelectedCell(true)
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
        rowFormer2.titleEditingColor = .redColor()
        
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
            segmentTitles: ["A", "B", "C"]
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
        rowFormer8.displayTextEditingColor = .redColor()
        
        let textFromDate: (NSDate -> String) = { date in
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = .currentLocale()
            dateFormatter.timeStyle = .NoStyle
            dateFormatter.dateStyle = .MediumStyle
            return dateFormatter.stringFromDate(date)
        }
        let rowFormer9 = InlineDatePickerRowFormer(
            cellType: FormerInlineDatePickerCell.self,
            registerType: .Class
        )
        rowFormer9.title = "InlineDatePicker"
        rowFormer9.datePickerMode = .Date
        rowFormer9.minimumDate = NSDate()
        rowFormer9.displayTextFromDate = textFromDate
        rowFormer9.displayTextEditingColor = .redColor()
        
        let rowFormer10 = TextViewRowFormer(
            cellType: FormerTextViewCell.self,
            registerType: .Class,
            textChangedHandler: { text in
                print(text)
            }
        )
        rowFormer10.title = "TextView"
        rowFormer10.placeholder = "Example"
        rowFormer10.titleEditingColor = .redColor()
        
        // Create SectionFormers
        
        let sectionFormer1 = SectionFormer()
            .addRowFormers(
                [rowFormer1, rowFormer2, rowFormer3,
                    rowFormer4, rowFormer5, rowFormer6,
                    rowFormer7, rowFormer8, rowFormer9,
                    rowFormer10]
            )
        
        self.former.addSectionFormer(sectionFormer1)
    }
}