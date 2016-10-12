//
//  CustomHomeCellView.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 9/30/16.
//
//

import Foundation
import UIKit
class CustomHomeCellView: UITableViewCell {
    
    
    @IBOutlet weak var publication_date: UILabel!
    @IBOutlet weak var publication_owner: UILabel!
    @IBOutlet weak var publication_description: UILabel!
    @IBOutlet weak var publication_image: UIImageView!
    var publication_url: String!
    
    func loadCell(item: HomeObject) {
        publication_url = Utilities.photo_url + "\(item.owner_id)/\(item.photo_name)"
        publication_owner.text = item.owner
        publication_description.text = item.photo_title
//        publication_date.text = Utilities.friendlyDate(date: item.date)
    }
}
