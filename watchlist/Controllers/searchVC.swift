//
//  searchViewController.swift
//  watchlist
//
//  Created by Clay Tercek on 1/29/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//

import UIKit

class searchVC: movieCollectionVC {
    

    
    @IBAction func cancelSearch(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self as? UISearchResultsUpdating
        self.navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        

        
    }
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }

    
    

}
