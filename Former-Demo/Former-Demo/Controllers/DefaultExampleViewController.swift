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
            row.tintColor = .formerColor()
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
                        sSelf.former.insertAndUpdate(rowFormers: sSelf.subRowFormers, toIndexPath: NSIndexPath(forRow: 1, inSection: 0), rowAnimation: .Middle)
                    } else {
                        sSelf.former.removeAndUpdate(rowFormers: sSelf.subRowFormers, rowAnimation: .Middle)
                    }
                }
        }
        mainSwitch.title = "Switch"
        mainSwitch.titleColor = .formerColor()
        mainSwitch.switchOnTintColor = .formerColor()
        mainSwitch.titleFont = .boldSystemFontOfSize(16.0)
        mainSwitch.switchWhenSelected = true
        mainSwitch.switched = false
        
        // Create SectionFormers
        
        let section1 = SectionFormer()
            .add(rowFormers: [mainSwitch])
        
        self.former.add(sectionFormers: [section1])
    }
}