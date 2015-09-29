//
//  TextSelectorViewContorller.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/10/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class TextSelectorViewContoller: FormViewController {
    
    var texts = [String]() {
        didSet {
            update()
        }
    }
    
    var selectedText: String? {
        didSet {
            former.rowFormers.forEach {
                if let textRowFormer = $0 as? TextRowFormer
                 where textRowFormer.text == selectedText {
                    textRowFormer.cellUpdate({
                        $0?.accessoryType = .Checkmark
                    })
                }
            }
        }
    }
    
    var onSelected: (String -> Void)?
    
    private func update() {
        
        // Create RowFormers
        
        let rowFormers = texts.map { text -> TextRowFormer in
            let rowFormer = TextRowFormer(
                cellType: FormTextCell.self,
                instantiateType: .Class,
                text: text) {
                    $0.titleLabel.textColor = .formerColor()
                    $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                    $0.tintColor = .formerSubColor()
                    if text == self.selectedText {
                        $0.accessoryType = .Checkmark
                    }
            }
            rowFormer.onSelected = { [weak self] _ in
                self?.onSelected?(text)
                self?.navigationController?.popViewControllerAnimated(true)
            }
            return rowFormer
        }
        
        // Create SectionFormers
        
        let sectionFormer = SectionFormer()
            .add(rowFormers: rowFormers)
        
        former.removeAll().add(sectionFormers: [sectionFormer]).reloadFormer()
    }
}