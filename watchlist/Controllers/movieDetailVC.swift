//
//  movieDetailViewController.swift
//  watchlist
//
//  Created by Clay Tercek on 1/28/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//

import UIKit

class movieDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        posterImage.layer.cornerRadius = 15
        posterImage.layer.masksToBounds = true
        posterImage.layer.borderWidth = 2
        posterImage.layer.backgroundColor = UIColor.white.cgColor
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
    
    }
    
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as! buttonCell
        
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let sizeW = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        let sizeH = Int(40)
        
        return CGSize(width: sizeW, height: sizeH)
    }


}
