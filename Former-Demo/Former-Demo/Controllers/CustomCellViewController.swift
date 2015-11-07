//
//  CustomCellViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 11/7/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class CustomCellViewController: FormViewController {
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: Private
    
    private func configure() {
        title = "Custom Cell"
        
        // Create RowFormers
        
        let dynamicHeightRow = CustomRowFormer<DynamicHeightCell>(instantiateType: .Nib(nibName: "DynamicHeightCell")) {
            $0.title = "Dynamic height"
            $0.body = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."            
            }.configure {
                $0.rowHeight = UITableViewAutomaticDimension
        }
        /** [Tips] for iOS 7
         dynamicHeightRow.dynamicRowHeight { [weak dynamicHeightRow] tableView, _ in
             dynamicHeightRow?.cell.bounds.size.width = tableView.bounds.width
             dynamicHeightRow?.cell.layoutIfNeeded()
             return dynamicHeightRow?.cell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height ?? 0
         }
        **/
         
        let colorListRow = CustomRowFormer<ColorListCell>(instantiateType: .Nib(nibName: "ColorListCell"))
            .configure {
                $0.rowHeight = 60
        }
        
        // Create Headers
        
        let createSpaceHeader: (() -> ViewFormer) = {
            return CustomViewFormer<FormHeaderFooterView>()
                .configure {
                    $0.viewHeight = 30
            }
        }
        
        // Create Section
        
        let dynamicHeightSection = SectionFormer(rowFormer: dynamicHeightRow)
            .set(headerViewFormer: createSpaceHeader())
        let colorListSection = SectionFormer(rowFormer: colorListRow)
            .set(headerViewFormer: createSpaceHeader())
        
        former.append(sectionFormer: dynamicHeightSection, colorListSection)
    }
}