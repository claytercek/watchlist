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
    
    // Link context to persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray: [Item] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // LOAD DATA IN
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        // Reload table view
        collectionView.reloadData()
    }
    
    func getData() {
        // Read People Entity from CoreData into peopleArray
        do {
            itemArray = try context.fetch(Item.fetchRequest())
            print("People Entity Fetching Successfull")
        }
        catch {
            print("People Entity Fetching Failed")
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! movieCell
        cell.posterImage.image = nil
        cell.titleText.text = ""
        if let url = itemArray[indexPath.row].poster_path {
            apiFetcher.fetchImage(url: url, completionHandler: { image, _ in
                UIView.transition(with: cell.posterImage,
                                  duration:0.2,
                                  options: .transitionCrossDissolve,
                                  animations: { cell.posterImage.image = image },
                                  completion: nil)
            })
        } else {
            // No img
            cell.titleText.text = itemArray[indexPath.row].title
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
        if segue.identifier == "savedDetail"{
            let destinationViewController = segue.destination as! movieDetailVC
            
            guard let selectedCell = sender as? movieCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = collectionView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            
            let jsonObject: JSON = [
                "media_type": itemArray[indexPath.row].media_type!,
                "id": itemArray[indexPath.row].id,
                "title": itemArray[indexPath.row].title!
            ]
            
            destinationViewController.itemData = jsonObject
            destinationViewController.itemObj = itemArray[indexPath.row]
            if let cell = collectionView.cellForItem(at: indexPath) as? movieCell {
                destinationViewController.posterData = cell.posterImage.image
            }
            
            
        }
    }
    

}
