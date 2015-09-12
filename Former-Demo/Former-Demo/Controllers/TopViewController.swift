//
//  TopViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/5/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class TopViewContoller: FormerViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configure()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.former.deselect(true)
    }
    
    private func configure() {
        
        let backBarButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
        self.title = "Former"
        
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
        
        let createMenu: ((String, (() -> Void)?) -> TextRowFormer) = { text, onSelected in
            let rowFormer = TextRowFormer(cellType: FormerTextCell.self, registerType: .Class)
            rowFormer.onSelected = { _ in onSelected?() }
            rowFormer.text = text
            rowFormer.textColor = .formerColor()
            rowFormer.font = UIFont.boldSystemFontOfSize(16.0)
            rowFormer.accessoryType = .DisclosureIndicator
            return rowFormer
        }
        
        // Create Headers and Footers
        
        let createHeader: (String -> TextViewFormer) = {
            let header = TextViewFormer(viewType: FormerTextHeaderView.self, registerType: .Class, text: $0)
            header.textColor = .grayColor()
            header.font = .systemFontOfSize(14.0)
            header.viewHeight = 40.0
            return header
        }
        
        let createFooter: (String -> TextViewFormer) = {
            let footer = TextViewFormer(viewType: FormerTextFooterView.self, registerType: .Class, text: $0)
            footer.textColor = .grayColor()
            footer.font = .systemFontOfSize(14.0)
            footer.viewHeight = 100.0
            return footer
        }
        
        // Create SectionFormers
        
        let firstSection = SectionFormer()
            .add(rowFormers: firstComponets.map(createMenu))
            .set(headerViewFormer: createHeader("Real Example"))
        
        let secondSection = SectionFormer()
            .add(rowFormers: secondComponents.map(createMenu))
            .set(headerViewFormer: createHeader("Default UI"))
        
        let thirdSection = SectionFormer()
            .add(rowFormers: thirdComponents.map(createMenu))
            .set(headerViewFormer: createHeader("Usage Examples"))
            .set(footerViewFormer: createFooter("Former is a fully customizable Swift\"2.0\" library for easy creating UITableView based form.\n\nMIT License (MIT)"))
        
        self.former.add(sectionFormers: [firstSection, secondSection, thirdSection])
    }
}