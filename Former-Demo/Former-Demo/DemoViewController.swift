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
            placeholder: "Exaple",
            selectedHandler: { indexPath in
                print(indexPath)
            },
            textChangedHandler: { text in
                print(text)
            }
        )
        rowFormer2.titleTextEditingColor = .redColor()
        
        let rowFormer3 = CheckRowFormer(
            cellType: FormerCheckCell.self,
            registerType: .Class,
            checked: true,
            title: "Check",
            checkChangedHandler: { checked in
                print(checked)
            }
        )
        
        let rowFormer4 = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            registerType: .Class,
            switched: true,
            title: "Switch",
            switchChangedHandler:{ switched in
                print(switched)
            }
        )
        
        let header1 = TextViewFormer(viewType: FormerTextHeaderView.self, registerType: .Class)
        header1.text = "Header"
        
        let footer1 = TextViewFormer(viewType: FormerTextFooterView.self, registerType: .Class)
        footer1.text = "Footer Footer Footer\nFooter Footer Footer"
        footer1.viewHeight = 60
        
        let dammySectionFormer = SectionFormer()
            .setHeaderViewFormer(nil)
            .setFooterViewFormer(header1)
        
        let sectionFormer = SectionFormer()
            .addRowFormers([rowFormer1, rowFormer2, rowFormer3, rowFormer4])
            .setHeaderViewFormer(nil)
            .setFooterViewFormer(footer1)
        
        self.former.addSectionFormers([dammySectionFormer, sectionFormer])
            .reloadFormer()
    }
}

