//
//  movieDetailViewController.swift
//  watchlist
//
//  Created by Clay Tercek on 1/28/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AVFoundation

class movieDetailVC: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewText: UITextView!
    
    var itemData: JSON = []
//    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemObj: Item!
    var posterData:UIImage!
    var isLoading:Bool = true
    var type: String = "movie"
    var audioPlayer: AVAudioPlayer?
    private let apiFetcher = APIRequestFetcher()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        let fixedWidth = overviewText.frame.size.width
        let newSize = overviewText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        overviewText.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        self.title = (itemData["title"].exists()) ? itemData["title"].string : itemData["name"].string
        var count = 0
        for item in(self.navigationController?.navigationBar.subviews)! {
            for sub in item.subviews{
                if sub is UILabel{
                    if count == 1 {
                        break;
                    }
                    let titleLab :UILabel = sub as! UILabel
                    titleLab.numberOfLines = 0
                    titleLab.text = self.title
                    titleLab.lineBreakMode = .byWordWrapping
                    count = count + 1
                }
            }
            
        }
        self.navigationController?.navigationBar.layoutSubviews()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(itemData)
        type = itemData["media_type"].string!
        apiFetcher.getById(id: itemData["id"].int!, type: itemData["media_type"].string!, completionHandler: {
            [weak self] results, error in
            if case .failure = error {
                print("error")
                return
            }
            
            guard let results = results, !results.isEmpty else {
                print("error")
                return
            }
            self?.itemData = results
            self?.updateData()
        })
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        posterImage.layer.cornerRadius = 5
        posterImage.layer.masksToBounds = true
        posterImage.layer.backgroundColor = UIColor.white.cgColor
        posterImage.image = posterData
    }
    
    
    func updateData() {
        overviewText.text = itemData["overview"].string
        
        var genres:[String] = []
        
        for (_, subJson) in itemData["genres"] {
            genres.append(subJson["name"].string!)
        }
        
        genreLabel.text = genres.joined(separator: ", ")
        
        
        if (type == "movie") {
            timeLabel.text = "\( itemData["runtime"].int ?? 0) min"
            dateLabel.text = itemData["release_date"].string
            
        } else {
            timeLabel.text = "average runtime: \( itemData["episode_run_time"][0].int ?? 0) min"
            dateLabel.text = itemData["first_air_date"].string
            
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        playSound();
        
        print("Save data to CoreData")
        
        // Link context to persistentContainer
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // link peopleObj to entity People
        let itemObj = Item(context: context)
        
        debugPrint(type)
        
        // Update atrributes with entity
        itemObj.poster_path = itemData["poster_path"].string
        itemObj.title = (itemData["title"].exists()) ? itemData["title"].string : itemData["name"].string
        itemObj.id = Int32(itemData["id"].int!)
        itemObj.media_type = type
        
        // Save to Context back to CoreData
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // Pop this view controller
        let _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func deleteButton(_ sender: Any) {
        print("Delete Item")
        
        // Link context to persistentContainer
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(itemObj)
        let _ = navigationController?.popViewController(animated: true)
        
    }
    
    func playSound() {
        do {
            if let fileURL = Bundle.main.path(forResource: "smb_coin", ofType: "wav") {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                audioPlayer?.play()
            } else {
                print("No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
    }
    

}
