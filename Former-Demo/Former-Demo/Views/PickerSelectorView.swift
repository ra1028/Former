//
//  PickerSelectorView.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/18/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

final class PickerSelectorView: UIView {
    
    var onValueChanged: ((Int, String) -> Void)?
    var valueTitles: [String] = [] {
        didSet {
            self.pickerView.reloadAllComponents()
        }
    }
    var selectedRow: Int = 0 {
        didSet {
            self.pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
        }
    }
    var showsSelectionIndicator = true {
        didSet {
            self.pickerView.showsSelectionIndicator = showsSelectionIndicator
        }
    }
    
    private weak var pickerView: UIPickerView!
    private weak var lineView: UIView!
    
    init() {
        super.init(frame: CGRect(origin: CGPointZero, size: CGSize(width: 0, height: 216.0)))
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        self.backgroundColor = .whiteColor()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(self.selectedRow, inComponent: 0, animated: false)
        pickerView.showsSelectionIndicator = self.showsSelectionIndicator
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(pickerView, atIndex: 0)
        self.pickerView = pickerView
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(lineView, atIndex: 0)
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[line(0.5)]-15-[picker]-15-|",
                options: [],
                metrics: nil,
                views: ["picker": pickerView, "line": lineView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[picker]-0-|",
                options: [],
                metrics: nil,
                views: ["picker": pickerView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[line]-0-|",
                options: [],
                metrics: nil,
                views: ["line": lineView]
            )
        ]
        self.addConstraints(constraints.flatMap { $0 })
    }
}

extension PickerSelectorView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectedRow = row
        self.onValueChanged?(row, self.valueTitles[row])
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.valueTitles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.valueTitles[row]
    }
}