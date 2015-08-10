//
//  TextSelectorViewContorller.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/10/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

class TextSelectorViewContoller: FormerViewController {
    
    var texts = [String]() {
        didSet {
            self.update()
        }
    }
    
    var selectedText: String? {
        didSet {
            self.former.rowFormers.map { row -> Void in
                if let textRowFormer = row as? TextRowFormer
                 where textRowFormer.text == self.selectedText {
                    textRowFormer.accessoryType = .Checkmark
                }
            }
        }
    }
    
    var selectedHandler: (String -> Void)?
    
    private func update() {
        
        // Create RowFormers
        
        let rowFormers = texts.map { text -> TextRowFormer in
            let rowFormer = TextRowFormer(
                cellType: FormerTextCell.self,
                registerType: .Class,
                selectedHandler: { [weak self] _ in
                    self?.selectedHandler?(text)
                    self?.navigationController?.popViewControllerAnimated(true)
            })
            rowFormer.text = text
            rowFormer.textColor = .formerColor()
            rowFormer.font = .boldSystemFontOfSize(16.0)
            rowFormer.tintColor = .formerSubColor()
            if text == self.selectedText {
                rowFormer.accessoryType = .Checkmark
            }
            return rowFormer
        }
        
        // Create SectionFormers
        
        let sectionFormer = SectionFormer()
            .add(rowFormers: rowFormers)
        
        self.former
            .removeAll()
            .add(sectionFormers: [sectionFormer])
            .reloadFormer()
    }
}