//
//  FormerInputAccessoryView.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/13/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class FormerInputAccessoryView: UIToolbar {
    
    private weak var former: Former?
    private weak var leftArrow: UIBarButtonItem!
    private weak var rightArrow: UIBarButtonItem!
    
    init(former: Former) {
        super.init(frame: CGRect(origin: CGPoint(), size: CGSize(width: 0, height: 44)))
        self.former = former
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        leftArrow.isEnabled = former?.canBecomeEditingPrevious() ?? false
        rightArrow.isEnabled = former?.canBecomeEditingNext() ?? false
    }
    
    private func configure() {
        barTintColor = .white
        tintColor = .formerSubColor()
        clipsToBounds = true
        isUserInteractionEnabled = true
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let leftArrow = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 105)!, target: self, action: #selector(FormerInputAccessoryView.handleBackButton))
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 20
        let rightArrow = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 106)!, target: self, action: #selector(FormerInputAccessoryView.handleForwardButton))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FormerInputAccessoryView.handleDoneButton))
        let rightSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        setItems([leftArrow, space, rightArrow, flexible, doneButton, rightSpace], animated: false)
        self.leftArrow = leftArrow
        self.rightArrow = rightArrow
        
        let topLineView = UIView()
        topLineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLineView)
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLineView)
        
        let leftLineView = UIView()
        leftLineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        leftLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftLineView)
        
        let rightLineView = UIView()
        rightLineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        rightLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightLineView)
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[topLine(0.5)]",
                options: [],
                metrics: nil,
                views: ["topLine": topLineView]
            ),
            NSLayoutConstraint.constraints(
              withVisualFormat: "V:[bottomLine(0.5)]-0-|",
                options: [],
                metrics: nil,
                views: ["bottomLine": bottomLineView]
            ),
            NSLayoutConstraint.constraints(
              withVisualFormat: "V:|-10-[leftLine]-10-|",
                options: [],
                metrics: nil,
                views: ["leftLine": leftLineView]
            ),
            NSLayoutConstraint.constraints(
              withVisualFormat: "V:|-10-[rightLine]-10-|",
                options: [],
                metrics: nil,
                views: ["rightLine": rightLineView]
            ),
            NSLayoutConstraint.constraints(
              withVisualFormat: "H:|-0-[topLine]-0-|",
                options: [],
                metrics: nil,
                views: ["topLine": topLineView]
            ),
            NSLayoutConstraint.constraints(
              withVisualFormat: "H:|-0-[bottomLine]-0-|",
                options: [],
                metrics: nil,
                views: ["bottomLine": bottomLineView]
            ),
            NSLayoutConstraint.constraints(
              withVisualFormat: "H:|-84-[leftLine(0.5)]",
                options: [],
                metrics: nil,
                views: ["leftLine": leftLineView]
            ),
            NSLayoutConstraint.constraints(
              withVisualFormat: "H:[rightLine(0.5)]-74-|",
                options: [],
                metrics: nil,
                views: ["rightLine": rightLineView]
            )
        ]
        addConstraints(constraints.flatMap { $0 })
    }
    
    private dynamic func handleBackButton() {
        update()
        former?.becomeEditingPrevious()
    }
    
    private dynamic func handleForwardButton() {
        update()
        former?.becomeEditingNext()
    }
    
    private dynamic func handleDoneButton() {
        former?.endEditing()
    }
}
