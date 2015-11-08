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
        
        let colors = [
            UIColor(red: 0.1, green: 0.74, blue: 0.61, alpha: 1),
            UIColor(red: 0.12, green: 0.81, blue: 0.43, alpha: 1),
            UIColor(red: 0.17, green: 0.59, blue: 0.87, alpha: 1),
            UIColor(red: 0.61, green: 0.34, blue: 0.72, alpha: 1),
            UIColor(red: 0.2, green: 0.29, blue: 0.37, alpha: 1),
            UIColor(red: 0.95, green: 0.77, blue: 0, alpha: 1),
            UIColor(red: 0.91, green: 0.49, blue: 0.02, alpha: 1),
            UIColor(red: 0.91, green: 0.29, blue: 0.21, alpha: 1),
            UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1),
            UIColor(red: 0.58, green: 0.65, blue: 0.65, alpha: 1),
        ]
        
        let dynamicHeightRow = CustomRowFormer<DynamicHeightCell>(instantiateType: .Nib(nibName: "DynamicHeightCell")) {
            $0.title = "Dynamic height"
            $0.body = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            $0.bodyColor = colors[0]
            }.configure {
                $0.rowHeight = UITableViewAutomaticDimension
        }
        /** [Tips] Dynamic height row for iOS 7
         ** Set as follows, and set preferredMaxLayoutWidth to cell. refer to DynamicHeightCell.swift **
         dynamicHeightRow.dynamicRowHeight { [weak dynamicHeightRow] tableView, _ in
             dynamicHeightRow?.cell.bounds.size.width = tableView.bounds.width
             dynamicHeightRow?.cell.layoutIfNeeded()
             return dynamicHeightRow?.cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height ?? 0
         }
        **/
        
        let colorListRow = CustomRowFormer<ColorListCell>(instantiateType: .Nib(nibName: "ColorListCell")) {
            $0.colors = colors
            $0.select(0)
            $0.onColorSelected = { color in
                dynamicHeightRow.cellUpdate {
                    $0.bodyColor = color
                }
            }
            }.configure {
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