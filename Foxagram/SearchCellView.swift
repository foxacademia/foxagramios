//
//  SearchCellView.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 10/10/16.
//
//

import Foundation
import UIKit

class SearchCellView: UITableViewCell {
    
    @IBOutlet weak var search_result_image: UIImageView!
    @IBOutlet weak var search_result_name: UILabel!
    
    func loadItem(item: SearchResultObject) {
        search_result_name.text = item.name
    }
}
