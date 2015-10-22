//
//  DefaultExampleViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/7/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

private extension UITableViewRowAnimation {
    
    static func animationNames() -> [String] {
        return ["None", "Fade", "Right", "Left", "Top", "Bottom", "Middle", "Automatic"]
    }
    
    static func allAnimations() -> [UITableViewRowAnimation] {
        return [.None, .Fade, .Right, .Left, .Top, .Bottom, .Middle, .Automatic]
    }
}

final class DefaultExampleViewController: FormViewController {
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        former.deselect(true)
    }
    
    private func configure() {
        title = "Default Example"
        
        // Create RowFormers
        // Date Setting Example
        
        let dateRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>(
            inlineCellSetup: {
                $0.datePicker.datePickerMode = .DateAndTime
            }) {
                $0.titleLabel.text = "Date"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16)
                $0.displayLabel.textColor = .formerSubColor()
                $0.displayLabel.font = .boldSystemFontOfSize(14)
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.displayTextFromDate(String.mediumDateShortTime)
        
        let switchDateStyleRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Switch Date Style"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(16)
            $0.switchButton.onTintColor = .formerSubColor()
            }.configure {
                $0.switched = false
            }.onSwitchChanged { switched in
            dateRow.displayTextFromDate(switched ? String.fullDate : String.mediumDateShortTime)
            dateRow.inlineCellUpdate {
                $0.datePicker.datePickerMode = switched ? .Date : .DateAndTime
            }
            dateRow.update()
        }
        
        // Insert Rows Example
        
        let positions = ["Below", "Above"]
        
        let insertRowPositionRow = SegmentedRowFormer<FormSegmentedCell>(instantiateType: .Class) {
            $0.tintColor = .formerSubColor()
            }.configure {
                $0.segmentTitles = positions
                $0.selectedIndex = insertRowPosition.rawValue
            }.onSegmentSelected { [weak self] index, _ in
            self?.insertRowPosition = InsertPosition(rawValue: index)!
        }
        
        let insertRowAnimationRow = InlinePickerRowFormer<FormInlinePickerCell, UITableViewRowAnimation>(instantiateType: .Class) {
            $0.titleLabel.text = "Animation"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFontOfSize(14)
            }.configure {
                $0.pickerItems = UITableViewRowAnimation.animationNames().enumerate().map {
                    InlinePickerItem<UITableViewRowAnimation>(title: $0.element, value: UITableViewRowAnimation.allAnimations()[$0.index])
                }
                $0.selectedRow = UITableViewRowAnimation.allAnimations().indexOf(insertRowAnimation) ?? 0
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.onValueChanged { [weak self] in
                self?.insertRowAnimation = $0.value!
        }
        
        let insertRowsRow = SwitchRowFormer<FormSwitchCell> {
            $0.titleLabel.text = "Insert Rows"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(16)
            $0.switchButton.onTintColor = .formerSubColor()
        }
        
        // Insert Section Example
        
        let insertSectionRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Insert Section"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(16)
            $0.switchButton.onTintColor = .formerSubColor()
        }
        
        let insertSectionPositionRow = SegmentedRowFormer<FormSegmentedCell>(instantiateType: .Class) {
            $0.tintColor = .formerSubColor()
            }.configure {
                $0.segmentTitles = positions
                $0.selectedIndex = insertSectionPosition.rawValue
            }.onSegmentSelected { [weak self] index, _ in
                self?.insertSectionPosition = InsertPosition(rawValue: index)!
        }
        
        let insertSectionAnimationRow = InlinePickerRowFormer<FormInlinePickerCell, UITableViewRowAnimation>(instantiateType: .Class) {
            $0.titleLabel.text = "Animation"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFontOfSize(14)
            }.configure {
                $0.pickerItems = UITableViewRowAnimation.animationNames().enumerate().map {
                    InlinePickerItem<UITableViewRowAnimation>(title: $0.element, value: UITableViewRowAnimation.allAnimations()[$0.index])
                }
                $0.selectedRow = UITableViewRowAnimation.allAnimations().indexOf(insertSectionAnimation) ?? 0
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.onValueChanged { [weak self] in
                self?.insertSectionAnimation = $0.value!
        }
        
        // Selector Example
        
        let createSelectorRow = { (
            text: String,
            subText: String,
            onSelected: ((indexPath: NSIndexPath,rowFormer: RowFormer) -> Void)?
            ) -> RowFormer in
            return LabelRowFormer<FormLabelCell>() {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16)
                $0.subTextLabel.textColor = .formerSubColor()
                $0.subTextLabel.font = .boldSystemFontOfSize(14)
                $0.accessoryType = .DisclosureIndicator
                }.configure { form in
                    _ = onSelected.map { form.onSelected($0) }
                    form.text = text
                    form.subText = subText
            }
        }
        let options = ["Option1", "Option2", "Option3"]
        
        let pushSelectorRow = createSelectorRow("Push", options[0], pushSelectorRowSelected(options))
        
        let sheetSelectorRow = createSelectorRow("Sheet", options[0], sheetSelectorRowSelected(options))
        
        let pickerSelectorRow = SelectorPickerRowFormer<FormSelectorPickerCell, Any> {
            $0.titleLabel.text = "Picker"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFontOfSize(14)
            $0.accessoryType = .DisclosureIndicator
            }.configure {
                $0.inputViewUpdate {
                    $0.backgroundColor = .whiteColor()
                }
                $0.pickerItems = options.map { SelectorPickerItem<Any>(title: $0) }
                $0.inputAccessoryView = formerInputAccessoryView
                $0.displayEditingColor = .formerHighlightedSubColor()
        }
        
        // Custom Input Accessory View Example

        let textFields = (1...2).map { index -> RowFormer in
            return TextFieldRowFormer<FormTextFieldCell>() { [weak self] in
                $0.titleLabel.text = "Field\(index)"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16)
                $0.textField.textColor = .formerSubColor()
                $0.textField.font = .boldSystemFontOfSize(14)
                $0.textField.inputAccessoryView = self?.formerInputAccessoryView
                $0.textField.returnKeyType = .Next
                $0.tintColor = .formerColor()
                }.configure {
                    $0.placeholder = "Example"
            }
        }
        
        let inlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Any>() {
            $0.titleLabel.text = "Inline Picker"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFontOfSize(14)
            }.configure {
                $0.pickerItems = (1...20).map { InlinePickerItem<Any>(title: "Option\($0)") }
                $0.displayEditingColor = .formerHighlightedSubColor()
        }
        
        // Create Headers and Footers
        
        let createHeader: (String -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>() {
                $0.titleLabel.textColor = .grayColor()
                $0.titleLabel.font = .systemFontOfSize(14)
                $0.contentView.backgroundColor = .groupTableViewBackgroundColor()
                }.configure {
                    $0.text = text
                    $0.viewHeight = 40
            }
        }
        
        // Create SectionFormers
        
        let section1 = SectionFormer(rowFormers: [switchDateStyleRow, dateRow])
            .set(headerViewFormer: createHeader("Date Setting Example"))
        let section2 = SectionFormer(rowFormers: [insertRowsRow, insertRowPositionRow, insertRowAnimationRow])
            .set(headerViewFormer: createHeader("Insert Rows Example"))
        let section3 = SectionFormer(rowFormers: [insertSectionRow, insertSectionPositionRow, insertSectionAnimationRow])
            .set(headerViewFormer: createHeader("Insert Section Example"))
        let section4 = SectionFormer(rowFormers: [pushSelectorRow, sheetSelectorRow, pickerSelectorRow])
            .set(headerViewFormer: createHeader("Selector Example"))
        let section5 = SectionFormer(rowFormers: textFields + [inlinePickerRow])
            .set(headerViewFormer: createHeader("Custom Input Accessory View Example"))
            .set(footerViewFormer: CustomViewFormer<FormHeaderFooterView>())
        
        insertRowsRow.onSwitchChanged(insertRows(sectionTop: section2.firstRowFormer!, sectionBottom: section2.lastRowFormer!))
        insertSectionRow.onSwitchChanged(insertSection(relate: section3))
        
        former.add(sectionFormers:
            [section1, section2, section3, section4, section5]
        ).onCellSelected { [weak self] _ in
            self?.formerInputAccessoryView.update()
        }
    }
    
    // MARK: Private
    
    private enum InsertPosition: Int {
        case Below, Above
    }
    
    private var insertRowAnimation = UITableViewRowAnimation.Left
    private var insertSectionAnimation = UITableViewRowAnimation.Fade
    private var insertRowPosition: InsertPosition = .Below
    private var insertSectionPosition: InsertPosition = .Below
    
    private lazy var subRowFormers: [RowFormer] = {
        return (1...2).map { index -> RowFormer in
            return CheckRowFormer<FormCheckCell>() {
                $0.titleLabel.text = "Check\(index)"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16)
                $0.tintColor = .formerSubColor()
            }
        }
        }()
    
    private lazy var subSectionFormer: SectionFormer = {
        return SectionFormer(rowFormers: [
            CheckRowFormer<FormCheckCell>() {
                $0.titleLabel.text = "Check3"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16)
                $0.tintColor = .formerSubColor()
            }
            ])
        }()
    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = { [unowned self] in
        FormerInputAccessoryView(former: self.former)
        }()
    
    private func insertRows(sectionTop sectionTop: RowFormer, sectionBottom: RowFormer)(insert: Bool) {
        if insert {
            if insertRowPosition == .Below {
                former.insertUpdate(rowFormers: subRowFormers, below: sectionBottom, rowAnimation: insertRowAnimation)
            } else if insertRowPosition == .Above {
                former.insertUpdate(rowFormers: subRowFormers, above: sectionTop, rowAnimation: insertRowAnimation)
            }
        } else {
            former.removeUpdate(rowFormers: subRowFormers, rowAnimation: insertRowAnimation)
        }
    }
    
    private func insertSection(relate relate: SectionFormer)(insert: Bool) {
        if insert {
            if insertSectionPosition == .Below {
                former.insertUpdate(sectionFormers: [subSectionFormer], below: relate, rowAnimation: insertSectionAnimation)
            } else if insertSectionPosition == .Above {
                former.insertUpdate(sectionFormers: [subSectionFormer], above: relate, rowAnimation: insertSectionAnimation)
            }
        } else {
            former.removeUpdate(sectionFormers: [subSectionFormer], rowAnimation: insertSectionAnimation)
        }
    }
    
    private func pushSelectorRowSelected(options: [String])(insdexPath: NSIndexPath, rowFormer: RowFormer) {
        if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
            let controller = TextSelectorViewContoller()
            controller.texts = options
            controller.selectedText = rowFormer.subText
            controller.onSelected = {
                rowFormer.subText = $0
                rowFormer.update()
            }
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func sheetSelectorRowSelected(options: [String])(insdexPath: NSIndexPath, rowFormer: RowFormer) {
        if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            options.forEach { title in
                sheet.addAction(UIAlertAction(title: title, style: .Default, handler: { [weak rowFormer] _ in
                    rowFormer?.subText = title
                    rowFormer?.update()
                    })
                )
            }
            sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(sheet, animated: true, completion: nil)
            former.deselect(true)
        }
    }
}