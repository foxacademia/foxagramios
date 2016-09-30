//
//  CustomHomeSectionView.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 9/28/16.
//
//

import Foundation
import UIKit
import Alamofire

class CustomHomeSectionView: UIView {
    
    @IBOutlet weak var owner_label: UILabel!
    @IBOutlet weak var owner_image: UIImageView!
    
    func loadHeader(home_item: HomeObject) {
        owner_label.text = home_item.owner
    }
    
}
