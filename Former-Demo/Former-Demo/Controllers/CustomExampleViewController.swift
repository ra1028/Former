//
//  CustomExampleViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/29/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class CustomExampleViewController: FormerViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        
        self.title = "Custom Example"
        
        // Create RowFormers
        
        let sliderRow = DemoInlineSliderRowFormer(
            cellType: DemoDemoInlineSliderCell.self,
            instantiateType: .Class
        )
        sliderRow.title = "Inline Slider"
        sliderRow.titleColor = .formerColor()
        sliderRow.titleFont = .boldSystemFontOfSize(16.0)
        sliderRow.displayColor = UIColor(hue: 1.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        sliderRow.onValueChanged = { [weak sliderRow] in
            let value = 1.0 - CGFloat($0)
            sliderRow?.displayColor = UIColor(hue: value, saturation: value, brightness: value, alpha: 1.0)
            sliderRow?.update()
        }
        
        // Create Headers and Footers
        
        let createHeader: (String -> ViewFormer) = {
            let header = TextViewFormer(
                viewType: FormerTextHeaderView.self,
                instantiateType: .Class,
                text: $0)
            header.textColor = .grayColor()
            header.font = .systemFontOfSize(14.0)
            header.viewHeight = 40.0
            return header
        }
        
        // Create SectionFormers
        
        let section1 = SectionFormer()
            .add(rowFormers: [sliderRow])
            .set(headerViewFormer: createHeader("Custom Inline Slider Row"))
        
        self.former.add(sectionFormers:
            [section1]
        )
    }
}