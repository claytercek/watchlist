//
//  UITextViewFixed.swift
//  watchlist
//
//  Created by Clay Tercek on 1/21/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//

import UIKit

@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
