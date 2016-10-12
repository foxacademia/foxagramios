//
//  CommentObject.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 10/5/16.
//
//

import Foundation

class CommentObject: NSObject {
    var owner_id: Int
    var owner: String
    var owner_image: String
    var comment_id: Int
    var comment_body: String
    
    init(item: JSON) {
        self.owner_id = item["user_id"].int ?? 0
        self.owner = item["User"]["names"].string ?? ""
        self.owner_image = item["User"]["user_image"].string ?? ""
        self.comment_id = item["id"].int ?? 0
        self.comment_body = item["comment_body"].string ?? ""
    }
}
