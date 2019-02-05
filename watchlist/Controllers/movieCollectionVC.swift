//
//  homeUICollectionViewController.swift
//  watchlist
//
//  Created by Clay Tercek on 1/28/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//

import UIKit
import SwiftyJSON

private let reuseIdentifier = "movieItem"

class movieCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let data = NSData(contentsOfFile: "../SupportFiles/dummyData.json")
    private let apiFetcher = APIRequestFetcher()
    private var savedMovies = JSON() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "dummyData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSON(data: data)
                savedMovies = jsonResult
                    // do stuff
            }
             catch {
                // handle error
            }
        }
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMovies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! movieCell
        cell.posterImage.image = nil
        if let url = savedMovies[indexPath.row]["poster_path"].string {
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
