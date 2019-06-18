//
//  ExampleViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/7/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

private extension UITableView.RowAnimation {
    
    static func names() -> [String] {
        return ["None", "Fade", "Right", "Left", "Top", "Bottom", "Middle", "Automatic"]
    }
    
    static func all() -> [UITableView.RowAnimation] {
        return [.none, .fade, .right, .left, .top, .bottom, .middle, .automatic]
    }
}

final class ExampleViewController: FormViewController {
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        former.deselect(animated: true)
    }
    
    private func configure() {
        title = "Examples"
        tableView.contentInset.bottom = 30
        
        // Create RowFormers
        // Date Setting Example
        
        let inputAccessoryView = FormerInputAccessoryView(former: former)
        
        let dateRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Date"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFont(ofSize: 14)
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .dateAndTime
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.displayTextFromDate(String.mediumDateShortTime)
        
        let switchDateStyleRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Switch Date Style"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.switchButton.onTintColor = .formerSubColor()
            }.configure {
                $0.switched = false
            }.onSwitchChanged { switched in
                dateRow.displayTextFromDate(switched ? String.fullDate : String.mediumDateShortTime)
                dateRow.inlineCellUpdate {
                    $0.datePicker.datePickerMode = switched ? .date : .dateAndTime
                }
                dateRow.update()
        }
        
        // Custom Check Row Example
        
        let customCheckRow = CheckRowFormer<FormCheckCell>() {
            $0.titleLabel.text = "Custom Check Icon"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            }.configure {
                let check = UIImage(named: "check")!.withRenderingMode(.alwaysTemplate)
                let checkView = UIImageView(image: check)
                checkView.tintColor = .formerSubColor()
                $0.customCheckView = checkView
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
        
        let insertRowAnimationRow = InlinePickerRowFormer<FormInlinePickerCell, UITableView.RowAnimation>(instantiateType: .Class) {
            $0.titleLabel.text = "Animation"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFont(ofSize: 14)
            }.configure {
                $0.pickerItems = UITableView.RowAnimation.names().enumerated().map {
                    InlinePickerItem(title: $0.element, value: UITableView.RowAnimation.all()[$0.offset])
                }
                $0.selectedRow = UITableView.RowAnimation.all().firstIndex(of: insertRowAnimation) ?? 0
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.onValueChanged { [weak self] in
                self?.insertRowAnimation = $0.value!
        }
        
        let insertRowsRow = SwitchRowFormer<FormSwitchCell> {
            $0.titleLabel.text = "Insert Rows"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.switchButton.onTintColor = .formerSubColor()
        }
        
        // Insert Section Example
        
        let insertSectionRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Insert Section"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
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
        
        let insertSectionAnimationRow = InlinePickerRowFormer<FormInlinePickerCell, UITableView.RowAnimation>(instantiateType: .Class) {
            $0.titleLabel.text = "Animation"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFont(ofSize: 14)
            }.configure {
                $0.pickerItems = UITableView.RowAnimation.names().enumerated().map {
                    InlinePickerItem(title: $0.element, value: UITableView.RowAnimation.all()[$0.offset])
                }
                $0.selectedRow = UITableView.RowAnimation.all().firstIndex(of: insertSectionAnimation) ?? 0
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.onValueChanged { [weak self] in
                self?.insertSectionAnimation = $0.value!
        }
        
        // Selector Example
        
        let createSelectorRow = { (
            text: String,
            subText: String,
            onSelected: ((RowFormer) -> Void)?
            ) -> RowFormer in
            return LabelRowFormer<FormLabelCell>() {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 16)
                $0.subTextLabel.textColor = .formerSubColor()
                $0.subTextLabel.font = .boldSystemFont(ofSize: 14)
                $0.accessoryType = .disclosureIndicator
                }.configure { form in
                    _ = onSelected.map { form.onSelected($0) }
                    form.text = text
                    form.subText = subText
            }
        }
        let options = ["Option1", "Option2", "Option3"]
        
        let pushSelectorRow = createSelectorRow("Push", options[0], pushSelectorRowSelected(options: options))
        
        let sheetSelectorRow = createSelectorRow("Sheet", options[0], sheetSelectorRowSelected(options: options))
        
        let pickerSelectorRow = SelectorPickerRowFormer<FormSelectorPickerCell, Any> {
            $0.titleLabel.text = "Picker"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFont(ofSize: 14)
            $0.accessoryType = .disclosureIndicator
            }.configure {
                $0.selectorViewUpdate {
                    $0.backgroundColor = .white
                }
                $0.pickerItems = options.map { SelectorPickerItem(title: $0) }
                $0.inputAccessoryView = inputAccessoryView
                $0.displayEditingColor = .formerHighlightedSubColor()
        }
        
        // Custom Input Accessory View Example

        let textFields = (1...2).map { index -> RowFormer in
            return TextFieldRowFormer<FormTextFieldCell>() {
                $0.titleLabel.text = "Field\(index)"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 16)
                $0.textField.textColor = .formerSubColor()
                $0.textField.font = .boldSystemFont(ofSize: 14)
                $0.textField.inputAccessoryView = inputAccessoryView
                $0.textField.returnKeyType = .next
                $0.tintColor = .formerColor()
                }.configure {
                    $0.placeholder = "Example"
            }
        }
        
        let inlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Any>() {
            $0.titleLabel.text = "Inline Picker"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFont(ofSize: 14)
            }.configure {
                $0.pickerItems = (1...20).map { InlinePickerItem(title: "Option\($0)") }
                $0.displayEditingColor = .formerHighlightedSubColor()
        }
        
        // Create Headers and Footers
        
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 44
            }
        }
        
        // Create SectionFormers
        
        let section1 = SectionFormer(rowFormer: switchDateStyleRow, dateRow)
            .set(headerViewFormer: createHeader("Date Setting Example"))
        let section2 = SectionFormer(rowFormer: customCheckRow)
            .set(headerViewFormer: createHeader("Custom Check Example"))
        let section3 = SectionFormer(rowFormer: insertRowsRow, insertRowPositionRow, insertRowAnimationRow)
            .set(headerViewFormer: createHeader("Insert Rows Example"))
        let section4 = SectionFormer(rowFormer: insertSectionRow, insertSectionPositionRow, insertSectionAnimationRow)
            .set(headerViewFormer: createHeader("Insert Section Example"))
        let section5 = SectionFormer(rowFormer: pushSelectorRow, sheetSelectorRow, pickerSelectorRow)
            .set(headerViewFormer: createHeader("Selector Example"))
        let section6 = SectionFormer(rowFormers: textFields + [inlinePickerRow])
            .set(headerViewFormer: createHeader("Custom Input Accessory View Example"))
        
        insertRowsRow.onSwitchChanged(insertRows(sectionTop: section3.firstRowFormer!, sectionBottom: section3.lastRowFormer!))
        insertSectionRow.onSwitchChanged(insertSection(relate: section4))
        
        former.append(sectionFormer:
            section1, section2, section3, section4, section5, section6
            ).onCellSelected { _ in
                inputAccessoryView.update()
        }
    }
    
    // MARK: Private
    
    private enum InsertPosition: Int {
        case Below, Above
    }
    
    private var insertRowAnimation = UITableView.RowAnimation.left
    private var insertSectionAnimation = UITableView.RowAnimation.fade
    private var insertRowPosition: InsertPosition = .Below
    private var insertSectionPosition: InsertPosition = .Below
    
    private lazy var subRowFormers: [RowFormer] = {
        return (1...2).map { index -> RowFormer in
            return CheckRowFormer<FormCheckCell>() {
                $0.titleLabel.text = "Check\(index)"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 16)
                $0.tintColor = .formerSubColor()
            }
        }
        }()
    
    private lazy var subSectionFormer: SectionFormer = {
        return SectionFormer(rowFormers: [
            CheckRowFormer<FormCheckCell>() {
                $0.titleLabel.text = "Check3"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 16)
                $0.tintColor = .formerSubColor()
            }
            ])
        }()
    
    private func insertRows(sectionTop: RowFormer, sectionBottom: RowFormer) -> (Bool) -> Void {
        return { [weak self] insert in
            guard let `self` = self else { return }
            if insert {
                if self.insertRowPosition == .Below {
                    self.former.insertUpdate(rowFormers: self.subRowFormers, below: sectionBottom, rowAnimation: self.insertRowAnimation)
                } else if self.insertRowPosition == .Above {
                    self.former.insertUpdate(rowFormers: self.subRowFormers, above: sectionTop, rowAnimation: self.insertRowAnimation)
                }
            } else {
                self.former.removeUpdate(rowFormers: self.subRowFormers, rowAnimation: self.insertRowAnimation)
            }
        }
    }
    
    private func insertSection(relate: SectionFormer) -> (Bool) -> Void {
        return { [weak self] insert in
            guard let `self` = self else { return }
            if insert {
                if self.insertSectionPosition == .Below {
                    self.former.insertUpdate(sectionFormers: [self.subSectionFormer], below: relate, rowAnimation: self.insertSectionAnimation)
                } else if self.insertSectionPosition == .Above {
                    self.former.insertUpdate(sectionFormers: [self.subSectionFormer], above: relate, rowAnimation: self.insertSectionAnimation)
                }
            } else {
                self.former.removeUpdate(sectionFormers: [self.subSectionFormer], rowAnimation: self.insertSectionAnimation)
            }
        }
    }
    
    private func pushSelectorRowSelected(options: [String]) -> (RowFormer) -> Void {
        return { [weak self] rowFormer in
            if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
                let controller = TextSelectorViewContoller()
                controller.texts = options
                controller.selectedText = rowFormer.subText
                controller.onSelected = {
                    rowFormer.subText = $0
                    rowFormer.update()
                }
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    private func sheetSelectorRowSelected(options: [String]) -> (RowFormer) -> Void {
        return { [weak self] rowFormer in
            if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
                let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                options.forEach { title in
                    sheet.addAction(UIAlertAction(title: title, style: .default, handler: { [weak rowFormer] _ in
                        rowFormer?.subText = title
                        rowFormer?.update()
                        })
                    )
                }
                sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(sheet, animated: true, completion: nil)
                self?.former.deselect(animated: true)
            }
        }
    }
}
