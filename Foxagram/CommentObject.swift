//
//  CommentObject.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 10/5/16.
//
//

import Foundation

class CommentObject: NSObject {
    let owner_id: Int
    let owner: String
    let owner_image: String
    let comment_id: Int
    let comment_body: String
    
    init(item: JSON) {
        self.owner_id = item["user_id"].int!
        self.owner = item["names"].string ?? ""
        self.owner_image = item["user_image"].string ?? ""
        self.comment_id = item["comment_id"].int ?? 0
        self.comment_body = item["comment_body"].string ?? ""
    }
}
