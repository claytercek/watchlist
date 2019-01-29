//
//  searchViewController.swift
//  watchlist
//
//  Created by Clay Tercek on 1/29/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//

import UIKit

class searchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    @IBAction func cancelSearch(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        

        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieItem", for: indexPath) as! movieItemCollectionViewCell
        
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
