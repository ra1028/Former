//
//  DefaultExampleViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/7/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

class DefaultExampleViewController: FormerViewController {
    
    private lazy var subRowFormers: [RowFormer] = {
        
        return (1...2).map { index -> RowFormer in
            let row = CheckRowFormer(
                cellType: FormerCheckCell.self,
                registerType: .Class) { check in
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
            registerType: .Class
        )
        rowFormer.title = "Check3"
        rowFormer.titleColor = .formerColor()
        rowFormer.titleFont = .boldSystemFontOfSize(16.0)
        rowFormer.tintColor = .formerSubColor()
        return SectionFormer().add(rowFormers: [rowFormer])
        }()
    
    private lazy var textFieldAccessoryView: TextFieldAccessoryView = {
        
        let accessory = TextFieldAccessoryView()
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
    
    private var pickerSelectorView: PickerSelectorView?
    private var pickerViewBottom: NSLayoutConstraint?
    
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
        
        let selectors = (0...2).map { index -> TextRowFormer in
            
            let selector = TextRowFormer(
                cellType: FormerTextCell.self,
                registerType: .Class
            )
            let texts = ["Option1", "Option2", "Option3"]
            selector.onSelected = [
                { [weak self, weak selector] _ in
                    let controller = TextSelectorViewContoller()
                    controller.texts = texts
                    controller.selectedText = selector?.subText
                    controller.onSelected = {
                        selector?.subText = $0
                        selector?.update()
                    }
                    self?.navigationController?.pushViewController(controller, animated: true)
                },
                { [weak self] _ in
                    let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                    texts.map { title in
                        sheet.addAction(UIAlertAction(title: title, style: .Default, handler: { [weak selector] _ in
                            selector?.subText = title
                            selector?.update()
                            }))
                    }
                    sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                    self?.presentViewController(sheet, animated: true, completion: nil)
                    self?.former.deselect(true)
                },
                { [weak self, weak selector] _ in
                    if self?.pickerSelectorView == nil {
                        self?.showPickerSelectorView(
                            texts,
                            selectedTitle: selector?.subText ?? texts[0],
                            onValueChanged: { (_, text) -> Void in
                                selector?.subText = text
                                selector?.update()
                        })
                    } else {
                        self?.hidePickerSelectorView()
                    }
                    self?.former.deselect(true)
                }
                ][index]
            selector.text = ["Push", "Sheet", "Picker"][index]
            selector.textColor = .formerColor()
            selector.font = .boldSystemFontOfSize(16.0)
            selector.subText = texts.first
            selector.subTextColor = .formerSubColor()
            selector.subTextFont = .boldSystemFontOfSize(14.0)
            selector.accessoryType = .DisclosureIndicator
            return selector
        }

        let textFields = (1...2).map { index -> TextFieldRowFormer in
            let input = TextFieldRowFormer(
                cellType: FormerTextFieldCell.self,
                registerType: .Class
            )
            input.title = "Field\(index)"
            input.placeholder = "Example"
            input.titleColor = .formerColor()
            input.textColor = .formerSubColor()
            input.tintColor = .formerColor()
            input.font = .boldSystemFontOfSize(16.0)
            input.textAlignment = .Right
            input.inputAccessoryView = self.textFieldAccessoryView
            input.returnKeyType = .Next
            return input
        }
        
        let picker = InlinePickerRowFormer(
            cellType: FormerInlinePickerCell.self,
            registerType: .Class
        )
        picker.title = "Inline Picker"
        picker.titleColor = .formerColor()
        picker.titleFont = .boldSystemFontOfSize(16.0)
        picker.displayTextColor = .formerSubColor()
        picker.displayTextEditingColor = .formerHighlightedSubColor()
        picker.displayTextFont = .boldSystemFontOfSize(14.0)
        picker.valueTitles = (1...20).map { "Option\($0)" }
        
        let insertCells = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            registerType: .Class) { [weak self] in
                if let sSelf = self {
                    if $0 {
                        sSelf.former.insertAndUpdate(rowFormers: sSelf.subRowFormers, toIndexPath: NSIndexPath(forRow: 1, inSection: 2), rowAnimation: .Left)
                    } else {
                        sSelf.former.removeAndUpdate(rowFormers: sSelf.subRowFormers, rowAnimation: .Right)
                    }
                }
        }
        insertCells.title = "Insert Rows"
        insertCells.titleColor = .formerColor()
        insertCells.switchOnTintColor = .formerSubColor()
        insertCells.titleFont = .boldSystemFontOfSize(16.0)
        
        let insertSection = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            registerType: .Class) { [weak self] in
                if let sSelf = self {
                    if $0 {
                        sSelf.former.insertAndUpdate(sectionFormers: [sSelf.subSectionFormer], toSection: 4, rowAnimation: .Fade)
                    } else {
                        sSelf.former.removeAndUpdate(sectionFormers: [sSelf.subSectionFormer], rowAnimation: .Fade)
                    }
                }
        }
        insertSection.title = "Insert Sections"
        insertSection.titleColor = .formerColor()
        insertSection.switchOnTintColor = .formerSubColor()
        insertSection.titleFont = .boldSystemFontOfSize(16.0)
        
        let date = InlineDatePickerRowFormer(
            cellType: FormerInlineDatePickerCell.self,
            registerType: .Class
        )
        date.title = "Date"
        date.titleColor = .formerColor()
        date.titleFont = .boldSystemFontOfSize(16.0)
        date.datePickerMode = .DateAndTime
        date.displayTextFromDate = String.mediumDateShortTime
        date.displayTextColor = .formerSubColor()
        date.displayTextEditingColor = .formerHighlightedSubColor()
        date.displayTextFont = .boldSystemFontOfSize(14.0)
        
        let switchDateStyle = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            registerType: .Class) {
                date.displayTextFromDate = $0 ? String.fullDate : String.mediumDateShortTime
                date.datePickerMode = $0 ? .Date : .DateAndTime
                date.update()
        }
        switchDateStyle.title = "Switch Date Style"
        switchDateStyle.titleColor = .formerColor()
        switchDateStyle.switchOnTintColor = .formerSubColor()
        switchDateStyle.titleFont = .boldSystemFontOfSize(16.0)
        switchDateStyle.switched = false
        
        // Create Headers and Footers
        
        let createHeader: (String -> ViewFormer) = {
            let header = TextViewFormer(
                viewType: FormerTextHeaderView.self,
                registerType: .Class,
                text: $0)
            header.textColor = .grayColor()
            header.font = .systemFontOfSize(14.0)
            header.viewHeight = 40.0
            return header
        }
        
        let footer = ViewFormer(
            viewType: FormerHeaderFooterView.self,
            registerType: .Class
        )
        
        // Create SectionFormers
        
        let section1 = SectionFormer()
            .add(rowFormers: selectors)
            .set(headerViewFormer: createHeader("Selector Example"))
        let section2 = SectionFormer()
            .add(rowFormers: textFields + [picker])
            .set(headerViewFormer: createHeader("Custom Input Accessory View Example"))
        let section3 = SectionFormer()
            .add(rowFormers: [insertCells])
            .set(headerViewFormer: createHeader("Insert Rows Example"))
        let section4 = SectionFormer()
            .add(rowFormers: [insertSection])
            .set(headerViewFormer: createHeader("Insert Section Example"))
        let section5 = SectionFormer()
            .add(rowFormers: [switchDateStyle, date])
            .set(headerViewFormer: createHeader("Date Setting Example"))
            .set(footerViewFormer: footer)
        
        self.former.add(sectionFormers: [
            section1, section2, section3, section4, section5
            ]
        )
        self.former.onCellSelected = { [weak self] indexPath in
            self?.textFieldAccessoryView.update()
            if self?.former.rowFormer(indexPath) !== selectors[2] {
                self?.hidePickerSelectorView()
            }
        }
        self.former.onBeginDragging = { [weak self] _ in
            self?.hidePickerSelectorView()
        }
    }
    
    private func showPickerSelectorView(valueTitles: [String], selectedTitle: String, onValueChanged: ((Int, String) -> Void)?) {
        
        let pickerSelectorView = PickerSelectorView()
        pickerSelectorView.valueTitles = valueTitles
        pickerSelectorView.selectedRow = valueTitles.indexOf(selectedTitle) ?? 0
        pickerSelectorView.onValueChanged = onValueChanged
        pickerSelectorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pickerSelectorView)
        self.pickerSelectorView = pickerSelectorView
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[picker(260)]",
                options: [],
                metrics: nil,
                views: ["picker": pickerSelectorView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[picker]-0-|",
                options: [],
                metrics: nil,
                views: ["picker": pickerSelectorView]
            )
        ]
        let pickerViewBottom = NSLayoutConstraint(
            item: pickerSelectorView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 260.0
        )
        self.view.addConstraints(constraints.flatMap { $0 } + [pickerViewBottom])
        self.pickerViewBottom = pickerViewBottom
        
        pickerSelectorView.layoutIfNeeded()
        
        UIView.animateWithDuration(
            0.25,
            delay: 0,
            options: [.BeginFromCurrentState, .CurveEaseOut],
            animations: { _ in
                pickerViewBottom.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil
        )
    }
    
    private func hidePickerSelectorView() {
        
        guard let pickerSelectorView = self.pickerSelectorView else { return }
        
        UIView.animateWithDuration(
            0.25,
            delay: 0,
            options: [.BeginFromCurrentState, .CurveEaseOut],
            animations: { () -> Void in
                self.pickerViewBottom?.constant = 260.0
                self.view.layoutIfNeeded()
            }) { _ in
                pickerSelectorView.removeConstraints(pickerSelectorView.constraints)
                pickerSelectorView.removeFromSuperview()
                self.pickerViewBottom = nil
                self.pickerSelectorView = nil
        }
    }
}