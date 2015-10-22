//
//  DemoDemoInlineSliderCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 9/6/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class DemoInlineSliderCell: UITableViewCell, DemoInlineSliderFormableRow {
    
    private(set) var titleLabel: UILabel!
    private(set) var colorDisplayView: UIView!
    private var displayColor: UIColor?
    
    func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    func formerColorDisplayView() -> UIView? {
        return colorDisplayView
    }
    
    func updateWithRowFormer(rowFormer: RowFormer) {}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if highlighted {
            displayColor = colorDisplayView.backgroundColor
        }
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            colorDisplayView.backgroundColor = displayColor
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        if selected {
            displayColor = colorDisplayView.backgroundColor
        }
        super.setSelected(selected, animated: animated)
        if selected {
            colorDisplayView.backgroundColor = displayColor
        }
    }
    
    func setup() {
        contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        textLabel?.backgroundColor = .clearColor()
        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let colorDisplayView = UIView()
        colorDisplayView.userInteractionEnabled = false
        colorDisplayView.translatesAutoresizingMaskIntoConstraints = false
        colorDisplayView.backgroundColor = .clearColor()
        colorDisplayView.layer.cornerRadius = 10
        contentView.insertSubview(colorDisplayView, atIndex: 0)
        self.colorDisplayView = colorDisplayView
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[title]-0-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[colorDisplay(20)]",
                options: [],
                metrics: nil,
                views: ["colorDisplay": colorDisplayView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-15-[colorDisplay(20)]-10-[title]",
                options: .AlignAllCenterY,
                metrics: nil,
                views: ["colorDisplay": colorDisplayView, "title": titleLabel]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}