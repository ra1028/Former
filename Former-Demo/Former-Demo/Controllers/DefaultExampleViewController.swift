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
        
        return (1...5).map { index -> RowFormer in
            let row = CheckRowFormer(
                cellType: FormerCheckCell.self,
                registerType: .Class) { check in
            }
            row.title = "Sub\(index)"
            row.titleColor = .formerColor()
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
        
        let mainSwitch = SwitchRowFormer(
            cellType: FormerSwitchCell.self,
            registerType: .Class) { [weak self] on in
                
                if let sSelf = self {
                    if on {
                        sSelf.former.insertRowFormersAndUpdate(sSelf.subRowFormers, toIndexPath: NSIndexPath(forRow: 1, inSection: 0), rowAnimation: .Middle)
                    } else {
                        sSelf.former.removeRowFormersAndUpdate(sSelf.subRowFormers, rowAnimation: .Middle)
                    }
                }
        }
        mainSwitch.title = "Switch"
        mainSwitch.titleColor = .formerColor()
        mainSwitch.titleFont = .boldSystemFontOfSize(16.0)
        mainSwitch.switched = false
        
        // Create SectionFormers
        
        let section1 = SectionFormer()
        .addRowFormers([mainSwitch])
        
        self.former.addSectionFormers([section1])
    }
}