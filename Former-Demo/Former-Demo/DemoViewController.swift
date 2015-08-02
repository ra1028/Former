//
//  DemoViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

class DemoViewController: FormerViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configure()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.former.reloadFormer()
    }
    
    private func configure() {
        
        self.title = "DemoViewController"
        self.view.backgroundColor = .groupTableViewBackgroundColor()
        
        let rowFormer1 = TextRowFormer(
            cellType: FormerTextCell.self,
            registerType: .Class,
            selectedHandler: { [weak self] indexPath in
                self?.former.deselectSelectedCell(true)
                print("Selected\(indexPath)")
            }
        )
        rowFormer1.text = "Former"
        rowFormer1.subText = "former"
        
        let rowFormer2 = TextFieldRowFormer(
            cellType: FormerTextFieldCell.self,
            registerType: .Class,
            textChangedHandler: { text in
                print(text)
            }
        )
        rowFormer2.title = "TextField"
        rowFormer2.placeholder = "Example"
        rowFormer2.titleEditingColor = .redColor()
        
        let rowFormer3 = CheckRowFormer(
            cellType: FormerCheckCell.self,
            registerType: .Class,
            checked: true,
            checkChangedHandler: { checked in
                print(checked)
            }
        )
        rowFormer3.title = "Check"
        
        let rowFormer4 = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            registerType: .Class,
            switchChangedHandler:{ switched in
                print(switched)
            }
        )
        rowFormer4.title = "Switch"
        
        let rowFormer5 = StepperRowFormer(
            cellType: FormerStepperCell.self,
            registerType: .Class) { value -> Void in
                print(value)
        }
        rowFormer5.title = "Stepper"
        rowFormer5.displayTextFromValue = { "\(Int($0))" }
        
        let rowFormer6 = SegmentedRowFormer(
            cellType: FormerSegmentedCell.self,
            registerType: .Class,
            segmentTitles: ["Apple", "Orange", "Grape"],
            segmentChangedHandler: { (index, title) in
                print("\(index), \(title)")
            }
        )
        rowFormer6.title = "Segmented"
        
        let rowFormer7 = SliderRowFormer(
            cellType: FormerSliderCell.self,
            registerType: .Class,
            sliderChangedHandler: { value in
                print(value)
            }
        )
        rowFormer7.title = "Slider"
        rowFormer7.adjustedValueFromValue = { Float(round($0 * 10) / 10) }
        rowFormer7.displayTextFromValue = { "\($0)" }
        
        let rowFormer8 = InlinePickerRowFormer(
            cellType: FormerInlinePickerCell.self,
            registerType: .Class,
            valueChangedHandler: { (row, title) in
                print("\(row), \(title)")
            }
        )
        rowFormer8.title = "InlinePicker"
        rowFormer8.valueTitles = ["A", "B", "C", "D", "E", "F"]
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
            registerType: .Class,
            dateChangedHandler: { date in
                print(textFromDate(date))
            }
        )
        rowFormer9.title = "InlineDatePicker"
        rowFormer9.datePickerMode = .Date
        rowFormer9.minimumDate = {
            let calendar = NSCalendar.currentCalendar()
            return calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: [])
            }()
        rowFormer9.displayTextFromDate = textFromDate
        rowFormer9.displayTextEditingColor = .redColor()
        
        let rowFormer11 = InlineDatePickerRowFormer(
            cellType: FormerInlineDatePickerCell.self,
            registerType: .Class,
            dateChangedHandler: { date in
                print(textFromDate(date))
            }
        )
        rowFormer11.title = "InlineDatePicker"
        rowFormer11.datePickerMode = .Date
        rowFormer11.minimumDate = {
            let calendar = NSCalendar.currentCalendar()
            return calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: [])
            }()
        rowFormer11.displayTextFromDate = textFromDate
        rowFormer11.displayTextEditingColor = .redColor()
        
        let rowFormer12 = InlineDatePickerRowFormer(
            cellType: FormerInlineDatePickerCell.self,
            registerType: .Class,
            dateChangedHandler: { date in
                print(textFromDate(date))
            }
        )
        rowFormer12.title = "InlineDatePicker"
        rowFormer12.datePickerMode = .Date
        rowFormer12.minimumDate = {
            let calendar = NSCalendar.currentCalendar()
            return calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: [])
            }()
        rowFormer12.displayTextFromDate = textFromDate
        rowFormer12.displayTextEditingColor = .redColor()
        
        let rowFormer13 = InlineDatePickerRowFormer(
            cellType: FormerInlineDatePickerCell.self,
            registerType: .Class,
            dateChangedHandler: { date in
                print(textFromDate(date))
            }
        )
        rowFormer13.title = "InlineDatePicker"
        rowFormer13.datePickerMode = .Date
        rowFormer13.minimumDate = {
            let calendar = NSCalendar.currentCalendar()
            return calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: [])
            }()
        rowFormer13.displayTextFromDate = textFromDate
        rowFormer13.displayTextEditingColor = .redColor()
        
        let rowFormer10 = TextViewRowFormer(
            cellType: FormerTextViewCell.self,
            registerType: .Class,
            textChangedHandler: { text in
                print(text)
            }
        )
        rowFormer10.cellHeight = 100
        rowFormer10.title = "TextView"
        rowFormer10.titleEditingColor = .redColor()
        rowFormer10.placeholder = "Example"
        
        let header1 = TextViewFormer(viewType: FormerTextHeaderView.self, registerType: .Class)
        header1.text = "Header1"
        
        let header2 = TextViewFormer(viewType: FormerTextHeaderView.self, registerType: .Class)
        header2.text = "Header2"
        
        let footer1 = TextViewFormer(viewType: FormerTextFooterView.self, registerType: .Class)
        footer1.text = "Footer Footer Footer\nFooter Footer Footer"
        footer1.viewHeight = 60
        
        let sectionFormer1 = SectionFormer()
            .addRowFormers(
                [rowFormer1, rowFormer2, rowFormer3,
                    rowFormer4, rowFormer5, rowFormer6,
                    rowFormer7, rowFormer8, rowFormer9, rowFormer11, rowFormer12]
            )
            .setHeaderViewFormer(header1)
        
        let sectionFormer2 = SectionFormer()
            .addRowFormers([rowFormer10, rowFormer13])
            .setHeaderViewFormer(header2)
            .setFooterViewFormer(footer1)
        
        self.former.addSectionFormers(
            [sectionFormer1,sectionFormer2]
            )
            .reloadFormer()
    }
}