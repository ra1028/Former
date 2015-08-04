//
//  FormerCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/25/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerCell: UITableViewCell, FormableRow {
    
    private weak var topSeparatorView: UIView!
    private weak var bottomSeparatorView: UIView!
    private weak var bottomSeparatorLeftConst: NSLayoutConstraint!
    private weak var bottomSeparatorRightConst: NSLayoutConstraint!
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.configure()
        self.configureViews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
        self.configureViews()
    }
    
    public func configureWithRowFormer(rowFormer: RowFormer) {
        
        self.topSeparatorView.backgroundColor = rowFormer.isTop ?
            rowFormer.separatorColor :
            .clearColor()
        self.bottomSeparatorView.backgroundColor = rowFormer.separatorColor
        self.bottomSeparatorLeftConst.constant = rowFormer.isBottom ? 0 : (rowFormer.separatorInsets?.left ?? 15.0)
        self.bottomSeparatorRightConst.constant = rowFormer.isBottom ? 0 : (rowFormer.separatorInsets?.right ?? 0)
    }
    
    public func configure() {
        
        self.contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.textLabel?.backgroundColor = .clearColor()
    }
    
    public func configureViews() {
        
        self.backgroundView = UIView()
        self.backgroundView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let topSeparatorView = UIView()
        topSeparatorView.userInteractionEnabled = false
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView?.insertSubview(topSeparatorView, atIndex: 0)
        self.topSeparatorView = topSeparatorView
        
        let bottomSeparatorView = UIView()
        bottomSeparatorView.userInteractionEnabled = false
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView?.insertSubview(bottomSeparatorView, atIndex: 0)
        self.bottomSeparatorView = bottomSeparatorView
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[separator(0.5)]",
                options: [],
                metrics: nil,
                views: ["separator": topSeparatorView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[separator(0.5)]-0-|",
                options: [],
                metrics: nil,
                views: ["separator": bottomSeparatorView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[separator]-0-|",
                options: [],
                metrics: nil,
                views: ["separator": topSeparatorView]
            )
        ]
        let bottomSeparatorLeftConst = NSLayoutConstraint(
            item: bottomSeparatorView,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: self.backgroundView,
            attribute: .Leading,
            multiplier: 1.0,
            constant: 0
        )
        let bottomSeparatorRightConst = NSLayoutConstraint(
            item: bottomSeparatorView,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: self.backgroundView,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: 0
        )
        
        self.backgroundView?.addConstraints(constraints.flatMap { $0 } + [bottomSeparatorLeftConst, bottomSeparatorRightConst])
        self.bottomSeparatorLeftConst = bottomSeparatorLeftConst
        self.bottomSeparatorRightConst = bottomSeparatorRightConst
    }
}