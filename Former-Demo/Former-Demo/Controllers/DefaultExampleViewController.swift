//
//  DefaultExampleViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/7/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

class DefaultExampleViewController: FormerViewController {
    
    private lazy var subRowFormers: [RowFormer] = {
        
        return (1...2).map { index -> RowFormer in
            let row = CheckRowFormer(
                cellType: FormerCheckCell.self,
                instantiateType: .Class) {
                    $0.titleLabel.text = "Check\(index)"
                    $0.titleLabel.textColor = .formerColor()
                    $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                    $0.tintColor = .formerSubColor()
            }
            return row
        }
        }()
    
    private lazy var subSectionFormer: SectionFormer = {
        let rowFormer = CheckRowFormer(
            cellType: FormerCheckCell.self,
            instantiateType: .Class) {
                $0.titleLabel.text = "Check3"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                $0.tintColor = .formerSubColor()
        }
        return SectionFormer().add(rowFormers: [rowFormer])
        }()
    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = {
        
        let accessory = FormerInputAccessoryView()
        accessory.doneButtonHandler = { [weak self] in
            self?.former.endEditing()
        }
        accessory.backButtonHandler = { [weak self] in
            self?.former.becomeEditingPrevious()
        }
        accessory.forwardButtonHandler = { [weak self] in
            self?.former.becomeEditingNext()
        }
        accessory.getBackButtonEnabled = { [weak self] in
            self?.former.canBecomeEditingPrevious() ?? true
        }
        accessory.getForwardButtonEnabled = { [weak self] in
            self?.former.canBecomeEditingNext() ?? true
        }
        return accessory
        }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configure()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.former.deselect(true)
    }
    
    private func configure() {
        
        self.title = "Default Example"
        
        // Create RowFormers
        
        // Date Setting Example
        
        let date = InlineDatePickerRowFormer(
            cellType: FormerInlineDatePickerCell.self,
            instantiateType: .Class,
            cellConfiguration: {
                $0.titleLabel.text = "Date"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                $0.displayLabel.textColor = .formerSubColor()
                $0.displayLabel.font = .boldSystemFontOfSize(14.0)
                $0.displayLabel.textAlignment = .Right
            }) {
                $0.datePicker.datePickerMode = .DateAndTime
        }
        date.displayTextFromDate = String.mediumDateShortTime
        date.displayEditingColor = .formerHighlightedSubColor()
        
        let switchDateStyle = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            instantiateType: .Class,
            onSwitchChanged: { switched in
                date.displayTextFromDate = switched ? String.fullDate : String.mediumDateShortTime
                date.inlineCellUpdate {
                    $0?.datePicker.datePickerMode = switched ? .Date : .DateAndTime
                }
                date.update()
            }) {
                $0.titleLabel.text = "Switch Date Style"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                $0.switchButton.onTintColor = .formerSubColor()
        }
        switchDateStyle.switched = false
        
        // Incert Rows Example
        
        let insertRows = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            instantiateType: .Class,
            onSwitchChanged: { [weak self] in
                guard let sSelf = self else { return }
                if $0 {
                    sSelf.former.insertAndUpdate(rowFormers: sSelf.subRowFormers, toIndexPath: NSIndexPath(forRow: 1, inSection: 1), rowAnimation: .Left)
                } else {
                    sSelf.former.removeAndUpdate(rowFormers: sSelf.subRowFormers, rowAnimation: .Right)
                }
            }) {
                $0.titleLabel.text = "Insert Rows"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                $0.switchButton.onTintColor = .formerSubColor()
        }
        
        // Insert Section Example
        
        let insertSection = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            instantiateType: .Class,
            onSwitchChanged: { [weak self] in
                guard let sSelf = self else { return }
                if $0 {
                    sSelf.former.insertAndUpdate(sectionFormers: [sSelf.subSectionFormer], toSection: 3, rowAnimation: .Fade)
                } else {
                    sSelf.former.removeAndUpdate(sectionFormers: [sSelf.subSectionFormer], rowAnimation: .Fade)
                }
            }) {
                $0.titleLabel.text = "Insert Section"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                $0.switchButton.onTintColor = .formerSubColor()
        }
        
        // Selector Example
        
        let options = ["Option1", "Option2", "Option3"]
        let selectors = (0...1).map { index -> TextRowFormer in
            
            let selector = TextRowFormer(
                cellType: FormerTextCell.self,
                instantiateType: .Class,
                cellConfiguration: {
                    $0.titleLabel.textColor = .formerColor()
                    $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                    $0.subTextLabel.textColor = .formerSubColor()
                    $0.subTextLabel.font = .boldSystemFontOfSize(14.0)
                    $0.subTextLabel.textAlignment = .Right
                    $0.accessoryType = .DisclosureIndicator
            })
            selector.subText = options.first
            selector.onSelected = [
                { [weak self] in
                    let selector = $1 as! TextRowFormer
                    let controller = TextSelectorViewContoller()
                    controller.texts = options
                    controller.selectedText = selector.subText
                    controller.onSelected = {
                        selector.subText = $0
                        selector.update()
                    }
                    self?.navigationController?.pushViewController(controller, animated: true)
                },
                { [weak self] in
                    let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                    let selector = $1 as! TextRowFormer
                    options.forEach { title in
                        sheet.addAction(UIAlertAction(title: title, style: .Default, handler: { [weak selector] _ in
                            selector?.subText = title
                            selector?.update()
                            })
                        )
                    }
                    sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                    self?.presentViewController(sheet, animated: true, completion: nil)
                    self?.former.deselect(true)
                }
                ][index]
            selector.text = ["Push", "Sheet", "Picker"][index]
            return selector
        }
        let pickerSelector = SelectorPickerRowFormer(
            cellType: FormerSelectorPickerCell.self,
            instantiateType: .Class) {
                $0.titleLabel.text = "Picker"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                $0.displayLabel.textColor = .formerSubColor()
                $0.displayLabel.font = .boldSystemFontOfSize(14.0)
                $0.displayLabel.textAlignment = .Right
                $0.accessoryType = .DisclosureIndicator
        }
        pickerSelector.inputViewUpdate {
            $0.backgroundColor = .whiteColor()
        }
        pickerSelector.valueTitles = options
        pickerSelector.inputAccessoryView = self.formerInputAccessoryView
        
        // Custom Input Accessory View Example

        let textFields = (1...2).map { index -> TextFieldRowFormer in
            let input = TextFieldRowFormer(
                cellType: FormerTextFieldCell.self,
                instantiateType: .Class,
                cellConfiguration: { [weak self] in
                    $0.titleLabel.text = "Field\(index)"
                    $0.titleLabel.textColor = .formerColor()
                    $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                    $0.textField.textColor = .formerSubColor()
                    $0.textField.font = .boldSystemFontOfSize(14.0)
                    $0.textField.textAlignment = .Right
                    $0.textField.inputAccessoryView = self?.formerInputAccessoryView
                    $0.textField.returnKeyType = .Next
                    $0.tintColor = .formerColor()
            })
            input.placeholder = "Example"
            return input
        }
        
        let picker = InlinePickerRowFormer(
            cellType: FormerInlinePickerCell.self,
            instantiateType: .Class,
            cellConfiguration: {
                $0.titleLabel.text = "Inline Picker"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                $0.displayLabel.textColor = .formerSubColor()
                $0.displayLabel.font = .boldSystemFontOfSize(14.0)
                $0.displayLabel.textAlignment = .Right
            })
        picker.valueTitles = (1...20).map { "Option\($0)" }
        picker.displayEditingColor = .formerHighlightedSubColor()
        
        // Create Headers and Footers
        
        let createHeader: (String -> ViewFormer) = {
            let header = TextViewFormer(
                viewType: FormerTextHeaderView.self,
                instantiateType: .Class,
                text: $0) {
                    $0.titleLabel.textColor = .grayColor()
                    $0.titleLabel.font = .systemFontOfSize(14.0)
            }
            header.viewHeight = 40.0
            return header
        }
        
        let footer = ViewFormer(
            viewType: FormerHeaderFooterView.self,
            instantiateType: .Class
        )
        
        // Create SectionFormers
        
        let section1 = SectionFormer()
            .add(rowFormers: [switchDateStyle, date])
            .set(headerViewFormer: createHeader("Date Setting Example"))
        let section2 = SectionFormer()
            .add(rowFormers: [insertRows])
            .set(headerViewFormer: createHeader("Insert Rows Example"))
        let section3 = SectionFormer()
            .add(rowFormers: [insertSection])
            .set(headerViewFormer: createHeader("Insert Section Example"))
        let section4 = SectionFormer()
            .add(rowFormers: selectors + [pickerSelector])
            .set(headerViewFormer: createHeader("Selector Example"))
        let section5 = SectionFormer()
            .add(rowFormers: textFields + [picker])
            .set(headerViewFormer: createHeader("Custom Input Accessory View Example"))
            .set(footerViewFormer: footer)
        
        self.former.add(sectionFormers:
            [section1, section2, section3, section4, section5]
        )
        self.former.onCellSelected = { [weak self] _ in
            self?.formerInputAccessoryView.update()
        }
    }
}