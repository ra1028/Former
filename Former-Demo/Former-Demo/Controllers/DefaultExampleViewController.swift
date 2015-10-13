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
        }
        dateRow.displayTextFromDate = String.mediumDateShortTime
        dateRow.displayEditingColor = .formerHighlightedSubColor()
        
        let switchDateStyleRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Switch Date Style"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(16)
            $0.switchButton.onTintColor = .formerSubColor()
        }
        switchDateStyleRow.onSwitchChanged = { switched in
            dateRow.displayTextFromDate = switched ? String.fullDate : String.mediumDateShortTime
            dateRow.inlineCellUpdate {
                $0.datePicker.datePickerMode = switched ? .Date : .DateAndTime
            }
            dateRow.update()
        }
        switchDateStyleRow.switched = false
        
        // Insert Rows Example
        
        let positions = ["Below", "Above"]
        
        let insertRowPositionRow = SegmentedRowFormer<FormSegmentedCell>(instantiateType: .Class) {
            $0.tintColor = .formerSubColor()
        }
        insertRowPositionRow.segmentTitles = positions
        insertRowPositionRow.selectedIndex = insertRowPosition.rawValue
        insertRowPositionRow.onSegmentSelected = { [weak self] index, _ in
            self?.insertRowPosition = InsertPosition(rawValue: index)!
        }
        
        let insertRowAnimationRow = InlinePickerRowFormer<FormInlinePickerCell, UITableViewRowAnimation>(instantiateType: .Class) {
            $0.titleLabel.text = "Animation"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFontOfSize(14)
        }
        insertRowAnimationRow.pickerItems = UITableViewRowAnimation.animationNames().enumerate().map {
            InlinePickerItem<UITableViewRowAnimation>(title: $0.element, value: UITableViewRowAnimation.allAnimations()[$0.index])
        }
        insertRowAnimationRow.selectedRow = UITableViewRowAnimation.allAnimations().indexOf(insertRowAnimation) ?? 0
        insertRowAnimationRow.displayEditingColor = .formerHighlightedSubColor()
        insertRowAnimationRow.onValueChanged = { [weak self] in
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
        }
        insertSectionPositionRow.segmentTitles = positions
        insertSectionPositionRow.selectedIndex = insertSectionPosition.rawValue
        insertSectionPositionRow.onSegmentSelected = { [weak self] index, _ in
            self?.insertSectionPosition = InsertPosition(rawValue: index)!
        }
        
        let insertSectionAnimationRow = InlinePickerRowFormer<FormInlinePickerCell, UITableViewRowAnimation>(instantiateType: .Class) {
            $0.titleLabel.text = "Animation"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFontOfSize(14)
        }
        insertSectionAnimationRow.pickerItems = UITableViewRowAnimation.animationNames().enumerate().map {
            InlinePickerItem<UITableViewRowAnimation>(title: $0.element, value: UITableViewRowAnimation.allAnimations()[$0.index])
        }
        insertSectionAnimationRow.selectedRow = UITableViewRowAnimation.allAnimations().indexOf(insertSectionAnimation) ?? 0
        insertSectionAnimationRow.displayEditingColor = .formerHighlightedSubColor()
        insertSectionAnimationRow.onValueChanged = { [weak self] in
            self?.insertSectionAnimation = $0.value!
        }
        
        // Selector Example
        
        let createSelectorRow = { (
            text: String,
            subText: String,
            onSelected: ((indexPath: NSIndexPath,rowFormer: RowFormer) -> Void)?
            ) -> RowFormer in
            let selectorRow = LabelRowFormer<FormTextCell>() {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16)
                $0.subTextLabel.textColor = .formerSubColor()
                $0.subTextLabel.font = .boldSystemFontOfSize(14)
                $0.accessoryType = .DisclosureIndicator
            }
            selectorRow.text = text
            selectorRow.subText = subText
            selectorRow.onSelected = onSelected
            return selectorRow
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
        }
        pickerSelectorRow.inputViewUpdate {
            $0.backgroundColor = .whiteColor()
        }
        pickerSelectorRow.pickerItems = options.map { SelectorPickerItem<Any>(title: $0) }
        pickerSelectorRow.inputAccessoryView = formerInputAccessoryView
        pickerSelectorRow.displayEditingColor = .formerHighlightedSubColor()
        
        // Custom Input Accessory View Example

        let textFields = (1...2).map { index -> RowFormer in
            let input = TextFieldRowFormer<FormTextFieldCell>() { [weak self] in
                $0.titleLabel.text = "Field\(index)"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16)
                $0.textField.textColor = .formerSubColor()
                $0.textField.font = .boldSystemFontOfSize(14)
                $0.textField.inputAccessoryView = self?.formerInputAccessoryView
                $0.textField.returnKeyType = .Next
                $0.tintColor = .formerColor()
            }
            input.placeholder = "Example"
            return input
        }
        
        let inlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Any>() {
            $0.titleLabel.text = "Inline Picker"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFontOfSize(14)
        }
        inlinePickerRow.pickerItems = (1...20).map { InlinePickerItem<Any>(title: "Option\($0)") }
        inlinePickerRow.displayEditingColor = .formerHighlightedSubColor()
        
        // Create Headers and Footers
        
        let createHeader: (String -> ViewFormer) = {
            let header = LabelViewFormer<FormTextHeaderView>() {
                $0.titleLabel.textColor = .grayColor()
                $0.titleLabel.font = .systemFontOfSize(14)
                $0.contentView.backgroundColor = .groupTableViewBackgroundColor()
            }
            header.text = $0
            header.viewHeight = 40
            return header
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
        
        insertRowsRow.onSwitchChanged = insertRows(sectionTop: section2.firstRowFormer!, sectionBottom: section2.lastRowFormer!)
        insertSectionRow.onSwitchChanged = insertSection(relate: section3)
        
        former.add(sectionFormers:
            [section1, section2, section3, section4, section5]
        )
        former.onCellSelected = { [weak self] _ in
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
            let row = CheckRowFormer<FormCheckCell>() {
                $0.titleLabel.text = "Check\(index)"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16)
                $0.tintColor = .formerSubColor()
            }
            return row
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
                former.insertAndUpdate(rowFormers: subRowFormers, below: sectionBottom, rowAnimation: insertRowAnimation)
            } else if insertRowPosition == .Above {
                former.insertAndUpdate(rowFormers: subRowFormers, above: sectionTop, rowAnimation: insertRowAnimation)
            }
        } else {
            former.removeAndUpdate(rowFormers: subRowFormers, rowAnimation: insertRowAnimation)
        }
    }
    
    private func insertSection(relate relate: SectionFormer)(insert: Bool) {
        if insert {
            if insertSectionPosition == .Below {
                former.insertAndUpdate(sectionFormers: [subSectionFormer], below: relate, rowAnimation: insertSectionAnimation)
            } else if insertSectionPosition == .Above {
                former.insertAndUpdate(sectionFormers: [subSectionFormer], above: relate, rowAnimation: insertSectionAnimation)
            }
        } else {
            former.removeAndUpdate(sectionFormers: [subSectionFormer], rowAnimation: insertSectionAnimation)
        }
    }
    
    private func pushSelectorRowSelected(options: [String])(insdexPath: NSIndexPath, rowFormer: RowFormer) {
        if let rowFormer = rowFormer as? LabelRowFormer<FormTextCell> {
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
        if let rowFormer = rowFormer as? LabelRowFormer<FormTextCell> {
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