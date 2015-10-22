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
            reloadForm()
        }
    }
    
    var selectedText: String? {
        didSet {
            former.rowFormers.forEach {
                if let LabelRowFormer = $0 as? LabelRowFormer<FormLabelCell>
                 where LabelRowFormer.text == selectedText {
                    LabelRowFormer.cellUpdate({ $0.accessoryType = .Checkmark })
                }
            }
        }
    }
    
    var onSelected: (String -> Void)?
    
    private func reloadForm() {
        
        // Create RowFormers
        
        let rowFormers = texts.map { text -> LabelRowFormer<FormLabelCell> in
            return LabelRowFormer<FormLabelCell>() { [weak self] in
                if let sSelf = self {
                    $0.titleLabel.textColor = .formerColor()
                    $0.titleLabel.font = .boldSystemFontOfSize(16)
                    $0.tintColor = .formerSubColor()
                    $0.accessoryType = (text == sSelf.selectedText) ? .Checkmark : .None
                }
                }.configure {
                    $0.text = text
                }.onSelected { [weak self] _ in
                    self?.onSelected?(text)
                    self?.navigationController?.popViewControllerAnimated(true)
            }
        }
        
        // Create SectionFormers
        
        let sectionFormer = SectionFormer(rowFormers: rowFormers)
        
        former.removeAll().append(sectionFormer: sectionFormer).reload()
    }
}