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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    // MARK: Private
    
    private let colors: [UIColor] = [
        UIColor(red: 0.1, green: 0.74, blue: 0.61, alpha: 1),
        UIColor(red: 0.12, green: 0.81, blue: 0.43, alpha: 1),
        UIColor(red: 0.17, green: 0.59, blue: 0.87, alpha: 1),
        UIColor(red: 0.61, green: 0.34, blue: 0.72, alpha: 1),
        UIColor(red: 0.2, green: 0.29, blue: 0.37, alpha: 1),
        UIColor(red: 0.95, green: 0.77, blue: 0, alpha: 1),
        UIColor(red: 0.91, green: 0.49, blue: 0.02, alpha: 1),
        UIColor(red: 0.91, green: 0.29, blue: 0.21, alpha: 1),
        UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1),
        UIColor(red: 0.58, green: 0.65, blue: 0.65, alpha: 1),
    ]
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath)
        let color = colors[indexPath.item]
        cell.contentView.backgroundColor = color
        return cell
    }
}