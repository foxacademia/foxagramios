//
//  CommentCellView.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 10/5/16.
//
//

import Foundation
import UIKit

class CommentCellView: UITableViewCell {
    
    @IBOutlet weak var owner_image: UIImageView!
    @IBOutlet weak var owner_name: UILabel!
    @IBOutlet weak var comment_body: UILabel!
    
    
    func loadItem(item: CommentObject) {
        self.owner_name.text = item.owner
        self.comment_body.text = item.comment_body
    
    }
    
    
    
}
