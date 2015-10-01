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
        
        let firstComponets: [(String, (() -> Void)?)] = [
            ("Edit Profile", { [weak self] in
                self?.navigationController?.pushViewController(DefaultUIViewController(), animated: true)})
        ]
        
        let secondComponents: [(String, (() -> Void)?)] = [
            ("All Defaults", { [weak self] in
                self?.navigationController?.pushViewController(DefaultUIViewController(), animated: true)})
        ]
        
        let thirdComponents: [(String, (() -> Void)?)] = [
            ("Default Former Examples", { [weak self] in
                self?.navigationController?.pushViewController(DefaultExampleViewController(), animated: true)}),
            ("Custom Former Examples", { [weak self] in
                self?.navigationController?.pushViewController(CustomExampleViewController(), animated: true)})
        ]
        
        let createMenu: ((String, (() -> Void)?) -> RowFormer) = { text, onSelected in
            let rowFormer = TextRowFormer<FormTextCell>() {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                $0.accessoryType = .DisclosureIndicator
            }
            rowFormer.text = text
            rowFormer.onSelected = { _ in onSelected?() }
            return rowFormer
        }
        
        // Create Headers and Footers
        
        let createHeader: (String -> ViewFormer) = {
            let header = TextViewFormer<FormTextHeaderView>() {
                $0.titleLabel.textColor = .grayColor()
                $0.titleLabel.font = .systemFontOfSize(14.0)
            }
            header.text = $0
            header.viewHeight = 40.0
            return header
        }
        
        let createFooter: (String -> ViewFormer) = {
            let footer = TextViewFormer<FormTextFooterView>() {
                $0.titleLabel.textColor = .grayColor()
                $0.titleLabel.font = .systemFontOfSize(14.0)
            }
            footer.text = $0
            footer.viewHeight = 100.0
            return footer
        }
        
        // Create SectionFormers
        
        let firstSection = SectionFormer(rowFormers: firstComponets.map(createMenu))
            .set(headerViewFormer: createHeader("Real Example"))
        
        let secondSection = SectionFormer(rowFormers: secondComponents.map(createMenu))
            .set(headerViewFormer: createHeader("Default UI"))
        
        let thirdSection = SectionFormer(rowFormers: thirdComponents.map(createMenu))
            .set(headerViewFormer: createHeader("Usage Examples"))
            .set(footerViewFormer: createFooter("Former is a fully customizable Swift2 library for easy creating UITableView based form.\n\nMIT License (MIT)"))
        
        former.add(sectionFormers: [firstSection, secondSection, thirdSection])
    }
}