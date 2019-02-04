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
        searchController.searchBar.placeholder = "Search for Movies or Series"
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
        cell.posterImage.image = nil
        if let url = searchResults[indexPath.row]["poster_path"].string {
            apiFetcher.fetchImage(url: url, completionHandler: { image, _ in
                UIView.transition(with: cell.posterImage,
                                  duration:0.2,
                                  options: .transitionCrossDissolve,
                                  animations: { cell.posterImage.image = image },
                                  completion: nil)
            })
        }
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchDetail"{
            let destinationViewController = segue.destination as! movieDetailVC
            
            guard let selectedCell = sender as? movieCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = collectionView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            destinationViewController.itemData = searchResults[indexPath.row]
            if let cell = collectionView.cellForItem(at: indexPath) as? movieCell {
                destinationViewController.posterData = cell.posterImage.image
            }
            
            
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
        let encoded:String = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        print("Text Searched: \(text), encoded: \(encoded)")
        apiFetcher.search(searchText: encoded, completionHandler: {
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
