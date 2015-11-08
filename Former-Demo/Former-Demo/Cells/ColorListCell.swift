//
//  ColorListCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 11/8/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

final class ColorListCell: UITableViewCell {
 
    // MARK: Public
    
    var colors = [UIColor]()
    var onColorSelected: (UIColor -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func select(item: Int, animated: Bool = false) {
        let indexPath = NSIndexPath(forItem: item, inSection: 0)
        collectionView.selectItemAtIndexPath(indexPath, animated: animated, scrollPosition: .None)
    }
    
    // MARK: Private
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private func configure() {
        selectionStyle = .None
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
    }
}

extension ColorListCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let length = collectionView.bounds.height
        return CGSize(width: length, height: length)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorCell", forIndexPath: indexPath) as! ColorCell
        cell.color = colors[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let color = colors[indexPath.item]
        onColorSelected?(color)
    }
}

private class ColorCell: UICollectionViewCell {
    
    // MARK: Public
    
    var color: UIColor? {
        get { return contentView.backgroundColor }
        set { contentView.backgroundColor = newValue }
    }
    override var selected: Bool {
        didSet { selectedView.hidden = !selected }
    }
    
    override var highlighted: Bool {
        didSet { contentView.alpha = highlighted ? 0.9 : 1 }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private weak var selectedView: UIView!
    
    private func configure() {
        let selectedView = UIView()
        selectedView.layer.borderWidth = 4
        selectedView.layer.borderColor = selectedView.tintColor.CGColor
        selectedView.userInteractionEnabled = false
        selectedView.hidden = !selected
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectedView)
        self.selectedView = selectedView
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[view]-0-|",
                options: [],
                metrics: nil,
                views: ["view": selectedView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[view]-0-|",
                options: [],
                metrics: nil,
                views: ["view": selectedView]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}