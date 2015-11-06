//
//  TopViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/5/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class TopViewContoller: FormViewController {
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        former.deselect(true)
    }
    
    // MARK: Private
    
    private func configure() {
        let backBarButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        title = "Former"
        
        // Create RowFormers
        
        let createMenu: ((String, (() -> Void)?) -> RowFormer) = { text, onSelected in
            return LabelRowFormer<FormLabelCell>() {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16)
                $0.accessoryType = .DisclosureIndicator
                }.configure {
                    $0.text = text
                }.onSelected { _ in
                    onSelected?()
            }
        }
        let realExampleRow = createMenu("Edit Profile") { [weak self] in
            self?.navigationController?.pushViewController(EditProfileViewController(), animated: true)
        }
        let defaultExampleRow = createMenu("Default RowFormer Examples") { [weak self] in
            self?.navigationController?.pushViewController(ExampleViewController(), animated: true)
        }
        let defaultRow = createMenu("All Defaults") { [weak self] in
            self?.navigationController?.pushViewController(DefaultRowFormerViewController(), animated: true)
        }
        
        // Create Headers and Footers
        
        let createHeader: (String -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 44
            }
        }
        
        let createFooter: (String -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelFooterView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 100
            }
        }
        
        // Create SectionFormers
        
        let firstSection = SectionFormer(rowFormer: realExampleRow)
            .set(headerViewFormer: createHeader("Real Example"))
        
        let secondSection = SectionFormer(rowFormer: defaultExampleRow)
            .set(headerViewFormer: createHeader("Usage Examples"))
        
        let thirdSection = SectionFormer(rowFormer: defaultRow)
            .set(headerViewFormer: createHeader("Default UI"))
            .set(footerViewFormer: createFooter("Former is a fully customizable Swift2 library for easy creating UITableView based form.\n\nMIT License (MIT)"))
        
        former.append(sectionFormer: firstSection, secondSection, thirdSection)
    }
}