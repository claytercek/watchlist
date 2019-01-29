//
//  homeUICollectionViewController.swift
//  watchlist
//
//  Created by Clay Tercek on 1/28/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//

import UIKit

private let reuseIdentifier = "movieItem"

class movieUICollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var lastOffsetY :CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! movieItemCollectionViewCell
        
        
        cell.posterImage.layer.cornerRadius = 15
        cell.posterImage.layer.masksToBounds = true
        cell.posterImage.layer.borderWidth = 2
        cell.posterImage.layer.backgroundColor = UIColor.white.cgColor
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.2
        cell.layer.masksToBounds = false

    
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 3
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let sizeW = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        let sizeH = Int(1.425 * (collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: sizeW, height: sizeH)
    }
    

}
