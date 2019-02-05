//
//  movieDetailViewController.swift
//  watchlist
//
//  Created by Clay Tercek on 1/28/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//

import UIKit
import SwiftyJSON

class movieDetailVC: UIViewController {
    @IBOutlet weak var posterImage: UIImageView!
    
    var itemData: JSON = []
    var posterData:UIImage!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        posterImage.layer.cornerRadius = 15
        posterImage.layer.masksToBounds = true
        posterImage.layer.backgroundColor = UIColor.white.cgColor
        posterImage.image = posterData
        
    
    }

}
