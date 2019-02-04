//
//  movieItemCollectionViewCell.swift
//  watchlist
//
//  Created by Clay Tercek on 1/28/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//


import UIKit

class movieCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    
    func getRandomColor() -> UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        posterImage.layer.cornerRadius = 15
        posterImage.layer.masksToBounds = true
        posterImage.layer.borderWidth = 0
        posterImage.layer.backgroundColor = UIColor.white.cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
    }
    
}
