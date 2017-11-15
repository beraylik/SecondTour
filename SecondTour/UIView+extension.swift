//
//  File.swift
//  SecondTour
//
//  Created by Gena Beraylik on 12.11.2017.
//  Copyright © 2017 Beraylik. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addConstraintsWith(format: String, views: [UIView]) {
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
