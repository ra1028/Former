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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        former.deselect(animated: true)
    }
    
    // MARK: Private
    
    private func configure() {
        let logo = UIImage(named: "header_logo")!
        navigationItem.titleView = UIImageView(image: logo)
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        
        // Create RowFormers
        
        let createMenu: ((String, (() -> Void)?) -> RowFormer) = { text, onSelected in
            return LabelRowFormer<FormLabelCell>() {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 16)
                $0.accessoryType = .disclosureIndicator
                }.configure {
                    $0.text = text
                }.onSelected { _ in
                    onSelected?()
            }
        }
        let editProfileRow = createMenu("Edit Profile") { [weak self] in
            self?.navigationController?.pushViewController(EditProfileViewController(), animated: true)
        }
        let addEventRow = createMenu("Add Event") { [weak self] in
            self?.navigationController?.pushViewController(AddEventViewController(), animated: true)
        }
        let loginRow = createMenu("Login") { [weak self] in
            _ = self.map { LoginViewController.present(viewController: $0) }
            self?.former.deselect(animated: true)
        }
        let exampleRow = createMenu("Examples") { [weak self] in
            self?.navigationController?.pushViewController(ExampleViewController(), animated: true)
        }
        let customCellRow = createMenu("Custom Cell") { [weak self] in
            self?.navigationController?.pushViewController(CustomCellViewController(), animated: true)
        }
        let defaultRow = createMenu("All Defaults") { [weak self] in
            self?.navigationController?.pushViewController(DefaultsViewController(), animated: true)
        }
        
        // Create Headers and Footers
        
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 40
            }
        }
        
        let createFooter: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelFooterView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 100
            }
        }
        
        // Create SectionFormers
        
        let realExampleSection = SectionFormer(rowFormer: editProfileRow, addEventRow, loginRow)
            .set(headerViewFormer: createHeader("Real Examples"))
        let useCaseSection = SectionFormer(rowFormer: exampleRow, customCellRow)
            .set(headerViewFormer: createHeader("Use Case"))
        let defaultSection = SectionFormer(rowFormer: defaultRow)
            .set(headerViewFormer: createHeader("Default UI"))
            .set(footerViewFormer: createFooter("Former is a fully customizable Swift5+ library for easy creating UITableView based form.\n\nMIT License (MIT)"))
        
        former.append(sectionFormer: realExampleSection, useCaseSection, defaultSection)
    }
}
