//
//  DeleteViewController.swift
//  Former-Demo
//
//  Created by ZhangShuai on 2021/2/9.
//  Copyright © 2021 Ryo Aoyama. All rights reserved.
//  This is a simple removable cell, available IOS 11 later

import UIKit
import Former

final class DeleteViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "Delete Cell"
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 30
        tableView.contentOffset.y = -10
        
        // Create RowFomers
        let titleRow = LabelRowFormer<CenterLabelCell>.init().configure(handler: {
            $0.text = "General Cell"
        })
        
        let removableCell = LabelRowFormer<CenterLabelCell>.init().configure(handler: {
            $0.text = "removable Cell"
            $0.isCanDeleted = true
            $0.deletedTitle = "remove cell"
        })
        .deletingCompleted { (row, index) in
            print("cell has benn removed at \(index) ")
        }

        // Create Headers
        let createHeader: (() -> ViewFormer) = {
            return CustomViewFormer<FormHeaderFooterView>()
                .configure {
                    $0.viewHeight = 20
            }
        }
        
        // Create SectionFormers
        let titleSection = SectionFormer(rowFormer: titleRow, removableCell).set(headerViewFormer: createHeader())
        former.append(sectionFormer: titleSection)
    }
}
