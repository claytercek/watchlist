//
//  MarginTableCellView.swift
//  watchlist
//
//  Created by Clay Tercek on 1/21/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//

import UIKit

@IBDesignable
class BorderTableCellView: UIView {
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
