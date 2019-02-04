//
//  searchViewController.swift
//  watchlist
//
//  Created by Clay Tercek on 1/29/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

private let reuseIdentifier = "movieItem"

class searchVC: movieCollectionVC {
    
    
    
    
    private var searchResults = [JSON]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let apiFetcher = APIRequestFetcher()
    private var previousRun = Date()
    private let minInterval = 0.05
    
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Movies or TV shows"
        definesPresentationContext = true
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        

        
    }
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! movieCell
        
        if let url = searchResults[indexPath.row]["poster_path"].string {
            apiFetcher.fetchImage(url: url, completionHandler: { image, _ in
                cell.posterImage.image = image
            })
        }
        
        return cell
    }
    
    private var selectedInt = 0
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedInt = indexPath.row
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint(selectedInt)
        if segue.identifier == "searchDetail"{
            let destinationViewController = segue.destination as! movieDetailVC
            destinationViewController.itemData = searchResults[selectedInt]
        }
    }

}



extension searchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            fetchResults(for: textToSearch)
        }
    }
    
    func fetchResults(for text: String) {
        print("Text Searched: \(text)")
        apiFetcher.search(searchText: text, completionHandler: {
            [weak self] results, error in
            if case .failure = error {
                return
            }
            
            guard let results = results, !results.isEmpty else {
                return
            }
            
            self?.searchResults = results
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
    }
    
}
