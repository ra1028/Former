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
    
    private func configure() {
        
        self.title = "DemoViewController"
        self.view.backgroundColor = .groupTableViewBackgroundColor()
        
        let rowFormer1 = TextRowFormer(
            cellType: FormerTextCell.self,
            registerType: .Class,
            text: "Apple",
            selectedHandler: { [weak self] indexPath in
                self?.former.deselectSelectedCell(true)
                print("Selected\(indexPath)")
            }
        )
        
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
        
        let rowFormer6 = TextViewRowFormer(
            cellType: FormerTextViewCell.self,
            registerType: .Class,
            textChangedHandler: { text in
                print(text)
            }
        )
        rowFormer6.cellHeight = 100
        rowFormer6.title = "TextView"
        rowFormer6.titleEditingColor = .redColor()
        rowFormer6.placeholder = "Example"
        
        let header1 = TextViewFormer(viewType: FormerTextHeaderView.self, registerType: .Class)
        header1.text = "Header1"
        
        let header2 = TextViewFormer(viewType: FormerTextHeaderView.self, registerType: .Class)
        header2.text = "Header2"
        header2.viewHeight = 50
        
        let footer1 = TextViewFormer(viewType: FormerTextFooterView.self, registerType: .Class)
        footer1.text = "Footer Footer Footer\nFooter Footer Footer"
        footer1.viewHeight = 60
        
        let sectionFormer1 = SectionFormer()
            .addRowFormers([rowFormer1, rowFormer2, rowFormer3, rowFormer4, rowFormer5])
            .setHeaderViewFormer(header1)
        
        let sectionFormer2 = SectionFormer()
            .addRowFormers([rowFormer6])
            .setHeaderViewFormer(header2)
            .setFooterViewFormer(footer1)
        
        self.former.addSectionFormers(
            [sectionFormer1,sectionFormer2]
            )
            .reloadFormer()
    }
}

