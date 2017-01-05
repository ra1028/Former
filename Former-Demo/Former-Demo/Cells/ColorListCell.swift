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
    var onColorSelected: ((UIColor) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func select(item: Int, animated: Bool = false) {
        let indexPath = IndexPath(item: item, section: 0)
        collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: [])
    }
    
    // MARK: Private
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private func configure() {
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
    }
}

extension ColorListCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = collectionView.bounds.height
        return CGSize(width: length, height: length)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.color = colors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    override var isSelected: Bool {
        didSet { selectedView.isHidden = !isSelected }
    }
    
    override var isHighlighted: Bool {
        didSet { contentView.alpha = isHighlighted ? 0.9 : 1 }
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
        selectedView.layer.borderColor = selectedView.tintColor.cgColor
        selectedView.isUserInteractionEnabled = false
        selectedView.isHidden = !isSelected
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectedView)
        self.selectedView = selectedView
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[view]-0-|",
                options: [],
                metrics: nil,
                views: ["view": selectedView]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[view]-0-|",
                options: [],
                metrics: nil,
                views: ["view": selectedView]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}
