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
        
        self.former.registerCellClass(FormerTextCell)
        self.former.registerCellClass(FormerTextFieldCell)
        self.former.registerCellClass(FormerCheckCell)
        self.former.registerViewClass(FormerTextHeaderView)
        self.former.registerViewClass(FormerTextFooterView)
        
        let rowFormer1 = TextRowFormer(
            cellType: FormerTextCell.self,
            text: "Apple",
            selectedHandler: { [weak self] indexPath in
                self?.former.deselectSelectedCell(true)
                print("Selected\(indexPath)")
            }
        )
        
        let rowFormer2 = TextFieldRowFormer(
            cellType: FormerTextFieldCell.self,
            title: "Title",
            placeholder: "Placeholder",
            textChangedHandler: { text in
                print(text)
            }
        )
        
        let rowFormer3 = CheckRowFormer(
            cellType: FormerCheckCell.self,
            checked: true,
            title: "Check",
            checkChangedHandler: { [weak self] checked in
                print(checked)
                self?.former.deselectSelectedCell(true)
            }
        )
        
        let header1 = TextViewFormer(viewType: FormerTextHeaderView.self)
        header1.text = "Header"
        header1.viewHeight = 60
        
        let footer1 = TextViewFormer(viewType: FormerTextFooterView.self)
        footer1.text = "Footer"
        footer1.viewHeight = 100
        
        let sectionFormer = SectionFormer()
        .addRowFormers([rowFormer1, rowFormer2, rowFormer3])
        .setHeaderViewFormer(header1)
        .setFooterViewFormer(footer1)
        
        self.former.addSectionFormer(sectionFormer)
        .reloadFormer()
    }
}

