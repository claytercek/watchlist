//
//  posterUIImageView.swift
//  watchlist
//
//  Created by Clay Tercek on 1/28/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//

import UIKit

class posterUIImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.shadowColor = UIColor.purple.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 1.0
        imageView.clipsToBounds = false
    }
}
