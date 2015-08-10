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
        
        return (1...3).map { index -> RowFormer in
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        
        self.title = "Default Example"
        
        // Create RowFormers
        
        let selector = TextRowFormer(
            cellType: FormerTextCell.self,
            registerType: .Class
        )
        selector.selectedHandler = { [weak self, weak selector] _ in
            self?.former.deselect(true)
            let controller = TextSelectorViewContoller()
            controller.texts = ["1", "2", "3"]
            controller.selectedText = selector?.subText
            controller.selectedHandler = {
                selector?.subText = $0
                selector?.update()
            }
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        selector.text = "Selector"
        selector.textColor = .formerColor()
        selector.font = .boldSystemFontOfSize(16.0)
        selector.subText = "1"
        selector.subTextColor = .formerSubColor()
        selector.subTextFont = .boldSystemFontOfSize(14.0)
        selector.accessoryType = .DisclosureIndicator
        
        let date1 = InlineDatePickerRowFormer(
            cellType: FormerInlineDatePickerCell.self,
            registerType: .Class
        )
        date1.title = "Date"
        date1.titleColor = .formerColor()
        date1.titleFont = .boldSystemFontOfSize(16.0)
        date1.datePickerMode = .DateAndTime
        date1.displayTextFromDate = String.mediumDateShortTime
        date1.displayTextEditingColor = .formerSubColor()
        date1.displayTextFont = .boldSystemFontOfSize(14.0)
        
        let switch1 = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            registerType: .Class) {
                date1.displayTextFromDate = $0 ? String.fullDate : String.mediumDateShortTime
                date1.datePickerMode = $0 ? .Date : .DateAndTime
                date1.update()
        }
        switch1.title = "Switch Date Style"
        switch1.titleColor = .formerColor()
        switch1.switchOnTintColor = .formerSubColor()
        switch1.titleFont = .boldSystemFontOfSize(16.0)
        switch1.switched = false
        
        let switch2 = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            registerType: .Class) { [weak self] in
                if let sSelf = self {
                    if $0 {
                        sSelf.former.insertAndUpdate(rowFormers: sSelf.subRowFormers, toIndexPath: NSIndexPath(forRow: 1, inSection: 2), rowAnimation: .Middle)
                    } else {
                        sSelf.former.removeAndUpdate(rowFormers: sSelf.subRowFormers, rowAnimation: .Middle)
                    }
                }
        }
        switch2.title = "Insert Check Cells"
        switch2.titleColor = .formerColor()
        switch2.switchOnTintColor = .formerSubColor()
        switch2.titleFont = .boldSystemFontOfSize(16.0)
        switch2.switched = false
        
        // Create SectionFormers
        
        let section1 = SectionFormer()
            .add(rowFormers: [selector])
        let section2 = SectionFormer()
            .add(rowFormers: [switch1, date1])
        let section3 = SectionFormer()
            .add(rowFormers: [switch2])
        
        self.former.add(sectionFormers: [
            section1, section2, section3
            ])
    }
}