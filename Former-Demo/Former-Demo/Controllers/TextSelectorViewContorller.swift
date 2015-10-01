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
    
    // MARK: Public
    
    var texts = [String]() {
        didSet {
            update()
        }
    }
    
    var selectedText: String? {
        didSet {
            former.rowFormers.forEach {
                if let textRowFormer = $0 as? TextRowFormer<FormTextCell>
                 where textRowFormer.text == selectedText {
                    textRowFormer.cellUpdate({ $0.accessoryType = .Checkmark })
                }
            }
        }
    }
    
    var onSelected: (String -> Void)?
    
    private func update() {
        
        // Create RowFormers
        
        let rowFormers = texts.map { text -> TextRowFormer<FormTextCell> in
            let rowFormer = TextRowFormer<FormTextCell>() { [weak self] in
                if let sSelf = self {
                    $0.titleLabel.textColor = .formerColor()
                    $0.titleLabel.font = .boldSystemFontOfSize(16.0)
                    $0.tintColor = .formerSubColor()
                    $0.accessoryType = (text == sSelf.selectedText) ? .Checkmark : .None
                }
            }
            rowFormer.text = text
            rowFormer.onSelected = { [weak self] _ in
                self?.onSelected?(text)
                self?.navigationController?.popViewControllerAnimated(true)
            }
            return rowFormer
        }
        
        // Create SectionFormers
        
        let sectionFormer = SectionFormer(rowFormers: rowFormers)
        
        former.removeAll().add(sectionFormers: [sectionFormer]).reload()
    }
}