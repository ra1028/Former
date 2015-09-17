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
                instantiateType: .Class) { check in
            }
            row.title = "Check\(index)"
            row.titleColor = .formerColor()
            row.tintColor = .formerSubColor()
            row.titleFont = .boldSystemFontOfSize(16.0)
            return row
        }
        }()
    
    private lazy var subSectionFormer: SectionFormer = {
        let rowFormer = CheckRowFormer(
            cellType: FormerCheckCell.self,
            instantiateType: .Class
        )
        rowFormer.title = "Check3"
        rowFormer.titleColor = .formerColor()
        rowFormer.titleFont = .boldSystemFontOfSize(16.0)
        rowFormer.tintColor = .formerSubColor()
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
            instantiateType: .Class
        )
        date.title = "Date"
        date.titleColor = .formerColor()
        date.titleFont = .boldSystemFontOfSize(16.0)
        date.datePickerMode = .DateAndTime
        date.displayTextFromDate = String.mediumDateShortTime
        date.displayTextColor = .formerSubColor()
        date.displayTextEditingColor = .formerHighlightedSubColor()
        date.displayTextFont = .boldSystemFontOfSize(14.0)
        date.displayTextAlignment = .Right
        
        let switchDateStyle = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            instantiateType: .Class) {
                date.displayTextFromDate = $0 ? String.fullDate : String.mediumDateShortTime
                date.datePickerMode = $0 ? .Date : .DateAndTime
                date.update()
        }
        switchDateStyle.title = "Switch Date Style"
        switchDateStyle.titleColor = .formerColor()
        switchDateStyle.titleFont = .boldSystemFontOfSize(16.0)
        switchDateStyle.switchOnTintColor = .formerSubColor()
        switchDateStyle.switched = false
        
        // Incert Rows Example
        
        let insertRows = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            instantiateType: .Class) { [weak self] in
                if let sSelf = self {
                    if $0 {
                        sSelf.former.insertAndUpdate(rowFormers: sSelf.subRowFormers, toIndexPath: NSIndexPath(forRow: 1, inSection: 1), rowAnimation: .Left)
                    } else {
                        sSelf.former.removeAndUpdate(rowFormers: sSelf.subRowFormers, rowAnimation: .Right)
                    }
                }
        }
        insertRows.title = "Insert Rows"
        insertRows.titleColor = .formerColor()
        insertRows.switchOnTintColor = .formerSubColor()
        insertRows.titleFont = .boldSystemFontOfSize(16.0)
        
        // Insert Section Example
        
        let insertSection = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            instantiateType: .Class) { [weak self] in
                if let sSelf = self {
                    if $0 {
                        sSelf.former.insertAndUpdate(sectionFormers: [sSelf.subSectionFormer], toSection: 3, rowAnimation: .Fade)
                    } else {
                        sSelf.former.removeAndUpdate(sectionFormers: [sSelf.subSectionFormer], rowAnimation: .Fade)
                    }
                }
        }
        insertSection.title = "Insert Section"
        insertSection.titleColor = .formerColor()
        insertSection.switchOnTintColor = .formerSubColor()
        insertSection.titleFont = .boldSystemFontOfSize(16.0)
        
        // Selector Example
        
        let options = ["Option1", "Option2", "Option3"]
        let selectors = (0...1).map { index -> TextRowFormer in
            
            let selector = TextRowFormer(
                cellType: FormerTextCell.self,
                instantiateType: .Class
            )
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
                    return
                }
                ][index]
            selector.text = ["Push", "Sheet", "Picker"][index]
            selector.textColor = .formerColor()
            selector.font = .boldSystemFontOfSize(16.0)
            selector.subText = options.first
            selector.subTextColor = .formerSubColor()
            selector.subTextFont = .boldSystemFontOfSize(14.0)
            selector.subTextAlignment = .Right
            selector.accessoryType = .DisclosureIndicator
            return selector
        }
        let pickerSelector = SelectorPickerRowFormer(
            cellType: FormerSelectorPickerCell.self,
            instantiateType: .Class
        )
        pickerSelector.title = "Picker"
        pickerSelector.titleColor = .formerColor()
        pickerSelector.titleFont = .boldSystemFontOfSize(16.0)
        pickerSelector.displayTextColor = .formerSubColor()
        pickerSelector.displayTextFont = .boldSystemFontOfSize(14.0)
        pickerSelector.displayTextAlignment = .Right
        pickerSelector.valueTitles = options
        pickerSelector.pickerBackgroundColor = .whiteColor()
        pickerSelector.accessoryType = .DisclosureIndicator
        pickerSelector.inputAccessoryView = self.formerInputAccessoryView
        
        // Custom Input Accessory View Example

        let textFields = (1...2).map { index -> TextFieldRowFormer in
            let input = TextFieldRowFormer(
                cellType: FormerTextFieldCell.self,
                instantiateType: .Class
            )
            input.title = "Field\(index)"
            input.placeholder = "Example"
            input.titleColor = .formerColor()
            input.textColor = .formerSubColor()
            input.tintColor = .formerColor()
            input.font = .boldSystemFontOfSize(16.0)
            input.textAlignment = .Right
            input.inputAccessoryView = self.formerInputAccessoryView
            input.returnKeyType = .Next
            return input
        }
        
        let picker = InlinePickerRowFormer(
            cellType: FormerInlinePickerCell.self,
            instantiateType: .Class
        )
        picker.title = "Inline Picker"
        picker.titleColor = .formerColor()
        picker.titleFont = .boldSystemFontOfSize(16.0)
        picker.displayTextColor = .formerSubColor()
        picker.displayTextEditingColor = .formerHighlightedSubColor()
        picker.displayTextFont = .boldSystemFontOfSize(14.0)
        picker.displayTextAlignment = .Right
        picker.valueTitles = (1...20).map { "Option\($0)" }
        
        // Create Headers and Footers
        
        let createHeader: (String -> ViewFormer) = {
            let header = TextViewFormer(
                viewType: FormerTextHeaderView.self,
                instantiateType: .Class,
                text: $0)
            header.textColor = .grayColor()
            header.font = .systemFontOfSize(14.0)
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