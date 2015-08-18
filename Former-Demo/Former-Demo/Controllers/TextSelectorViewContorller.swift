//
//  TextSelectorViewContorller.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/10/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

final class TextSelectorViewContoller: FormerViewController {
    
    var texts = [String]() {
        didSet {
            self.update()
        }
    }
    
    var selectedText: String? {
        didSet {
            self.former.rowFormers.forEach {
                if let textRowFormer = $0 as? TextRowFormer
                 where textRowFormer.text == self.selectedText {
                    textRowFormer.accessoryType = .Checkmark
                }
            }
        }
    }
    
    var onSelected: (String -> Void)?
    
    private func update() {
        
        // Create RowFormers
        
        let rowFormers = texts.map { text -> TextRowFormer in
            let rowFormer = TextRowFormer(
                cellType: FormerTextCell.self,
                registerType: .Class,
                onSelected: { [weak self] _ in
                    self?.onSelected?(text)
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