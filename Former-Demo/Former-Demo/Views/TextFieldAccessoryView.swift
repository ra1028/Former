//
//  TextFieldAccessoryView.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/13/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

final class TextFieldAccessoryView: UIToolbar {
    
    var backButtonHandler: (() -> Void)?
    var forwardButtonHandler: (() -> Void)?
    var doneButtonHandler: (() -> Void)?
    
    var getBackButtonEnabled: (() -> Bool)?
    var getForwardButtonEnabled: (() -> Bool)?
    
    private weak var leftArrow: UIBarButtonItem!
    private weak var rightArrow: UIBarButtonItem!
    
    init() {
        
        super.init(frame: CGRect(origin: CGPointZero, size: CGSize(width: 0, height: 44.0)))
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        
        self.leftArrow.enabled = self.getBackButtonEnabled?() ?? true
        self.rightArrow.enabled = self.getForwardButtonEnabled?() ?? true
    }
    
    private func configure() {
        
        self.barTintColor = .whiteColor()
        self.tintColor = .formerSubColor()
        self.userInteractionEnabled = true
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let leftArrow = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 105)!, target: self, action: "handleBackButton")
        let space = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        space.width = 20.0
        let rightArrow = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 106)!, target: self, action: "handleForwardButton")
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "handleDoneButton")
        let rightSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        self.setItems([leftArrow, space, rightArrow, flexible, doneButton, rightSpace], animated: false)
        self.leftArrow = leftArrow
        self.rightArrow = rightArrow
        
        let leftLineView = UIView()
        leftLineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        leftLineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftLineView)
        
        let rightLineView = UIView()
        rightLineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        rightLineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightLineView)
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-10-[leftLine]-10-|",
                options: [],
                metrics: nil,
                views: ["leftLine": leftLineView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-10-[rightLine]-10-|",
                options: [],
                metrics: nil,
                views: ["rightLine": rightLineView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-84-[leftLine(0.5)]",
                options: [],
                metrics: nil,
                views: ["leftLine": leftLineView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[rightLine(0.5)]-74-|",
                options: [],
                metrics: nil,
                views: ["rightLine": rightLineView]
            )
        ]
        self.addConstraints(constraints.flatMap { $0 })
    }
    
    private dynamic func handleBackButton() {
        
        self.update()
        self.backButtonHandler?()
    }
    
    private dynamic func handleForwardButton() {
        
        self.update()
        self.forwardButtonHandler?()
    }
    
    private dynamic func handleDoneButton() {
        
        self.doneButtonHandler?()
    }
}