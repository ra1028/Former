//
//  AddEventViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 11/6/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class AddEventViewController: FormViewController {
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: Private
    
    private enum Repeat {
        case Never, Daily, Weekly, Monthly, Yearly
        func title() -> String {
            switch self {
            case Never: return "Never"
            case Daily: return "Daily"
            case Weekly: return "Weekly"
            case Monthly: return "Monthly"
            case Yearly: return "Yearly"
            }
        }
        static func values() -> [Repeat] {
            return [Daily, Weekly, Monthly, Yearly]
        }
    }
    
    private enum Alert {
        case None, AtTime, Five, Thirty, Hour, Day, Week
        func title() -> String {
            switch self {
            case None: return "None"
            case AtTime: return "At time of event"
            case Five: return "5 minutes before"
            case Thirty: return "30 minutes before"
            case Hour: return "1 hour before"
            case Day: return "1 day before"
            case Week: return "1 week before"
            }
        }
        static func values() -> [Alert] {
            return [AtTime, Five, Thirty, Hour, Day, Week]
        }
    }
    
    private func configure() {
        title = "Add Event"
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 30
        tableView.contentOffset.y = -10
        
        // Create RowFomers
        
        let titleRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = .formerColor()
            $0.textField.font = .systemFontOfSize(15)
            }.configure {
                $0.placeholder = "Event title"
        }
        let locationRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = .formerColor()
            $0.textField.font = .systemFontOfSize(15)
            }.configure {
                $0.placeholder = "Location"
        }
        let startRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Start"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(15)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .systemFontOfSize(15)
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .DateAndTime
            }.displayTextFromDate(String.mediumDateShortTime)
        let endRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Start"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(15)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .systemFontOfSize(15)
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .DateAndTime
            }.displayTextFromDate(String.mediumDateShortTime)
        let allDayRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "All-day"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(15)
            $0.switchButton.onTintColor = .formerSubColor()
            }.onSwitchChanged { on in
                startRow.update {
                    $0.displayTextFromDate(
                        on ? String.mediumDateNoTime : String.mediumDateShortTime
                    )
                }
                startRow.inlineCellUpdate {
                    $0.datePicker.datePickerMode = on ? .Date : .DateAndTime
                }
                endRow.update {
                    $0.displayTextFromDate(
                        on ? String.mediumDateNoTime : String.mediumDateShortTime
                    )
                }
                endRow.inlineCellUpdate {
                    $0.datePicker.datePickerMode = on ? .Date : .DateAndTime
                }
        }
        let repeatRow = InlinePickerRowFormer<FormInlinePickerCell, Repeat>() {
            $0.titleLabel.text = "Repeat"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(15)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .systemFontOfSize(15)
            }.configure {
                let never = Repeat.Never
                $0.pickerItems.append(
                    InlinePickerItem(title: never.title(),
                        displayTitle: NSAttributedString(string: never.title(),
                            attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()]),
                        value: never)
                )
                $0.pickerItems += Repeat.values().map {
                    InlinePickerItem(title: $0.title(), value: $0)
                }
        }
        let alertRow = InlinePickerRowFormer<FormInlinePickerCell, Alert>() {
            $0.titleLabel.text = "Alert"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(15)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .systemFontOfSize(15)
            }.configure {
                let none = Alert.None
                $0.pickerItems.append(
                    InlinePickerItem(title: none.title(),
                        displayTitle: NSAttributedString(string: none.title(),
                            attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()]),
                        value: none)
                )
                $0.pickerItems += Alert.values().map {
                    InlinePickerItem(title: $0.title(), value: $0)
                }
        }
        let urlRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = .formerSubColor()
            $0.textField.font = .systemFontOfSize(15)
            $0.textField.keyboardType = .Alphabet
            }.configure {
                $0.placeholder = "URL"
        }
        let noteRow = TextViewRowFormer<FormTextViewCell>() {
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFontOfSize(15)
            }.configure {
                $0.placeholder = "Note"
                $0.rowHeight = 150
        }
        
        // Create Headers
        
        let createHeader: (() -> ViewFormer) = {
            return CustomViewFormer<FormHeaderFooterView>()
                .configure {
                    $0.viewHeight = 20
            }
        }
        
        // Create SectionFormers
        
        let titleSection = SectionFormer(rowFormer: titleRow, locationRow)
            .set(headerViewFormer: createHeader())
        let dateSection = SectionFormer(rowFormer: allDayRow, startRow, endRow)
            .set(headerViewFormer: createHeader())
        let repeatSection = SectionFormer(rowFormer: repeatRow, alertRow)
            .set(headerViewFormer: createHeader())
        let noteSection = SectionFormer(rowFormer: urlRow, noteRow)
            .set(headerViewFormer: createHeader())
        
        former.append(sectionFormer: titleSection, dateSection, repeatSection, noteSection)
    }
}