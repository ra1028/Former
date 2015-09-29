//
//  CustomExampleViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/29/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class CustomExampleViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "Custom Example"
        
        // Create RowFormers
        
        let sliderRow = DemoInlineSliderRowFormer(
            cellType: DemoInlineSliderCell.self,
            instantiateType: .Class) {
                $0.titleLabel.text = "Inline Slider"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFontOfSize(16.0)
        }
        sliderRow.color = UIColor(hue: 1.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        sliderRow.onValueChanged = { [weak sliderRow] in
            let value = 1.0 - CGFloat($0)
            sliderRow?.color = UIColor(hue: value, saturation: value, brightness: value, alpha: 1.0)
            sliderRow?.update()
        }
        
        // Create Headers and Footers
        
        let createHeader: (String -> ViewFormer) = {
            let header = TextViewFormer(
                viewType: FormTextHeaderView.self,
                instantiateType: .Class,
                text: $0) {
                    $0.titleLabel.textColor = .grayColor()
                    $0.titleLabel.font = .systemFontOfSize(14.0)
            }
            header.viewHeight = 40.0
            return header
        }
        
        // Create SectionFormers
        
        let section1 = SectionFormer()
            .add(rowFormers: [sliderRow])
            .set(headerViewFormer: createHeader("Custom Inline Slider Row"))
        
        former.add(sectionFormers:
            [section1]
        )
    }
}