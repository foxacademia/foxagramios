//
//  HomeObject.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 9/28/16.
//
//

import Foundation

class HomeObject: NSObject {
    let owner_id: Int
    let owner: String
    let owner_image: String
    let photo_name: String
    let photo_id: Int
    let photo_title: String
    let date: String
    let loved: Int
    
    init(item: JSON) {
        self.owner_id = item["user_id"].int!
        self.owner = item["names"].string ?? ""
        self.owner_image = item["user_image"].string ?? ""
        self.photo_name = item["file_name"].string ?? ""
        self.photo_id = item["photo_id"].int ?? 0
        self.photo_title = item["title"].string ?? ""
        self.date = item["date"].string ?? ""
        self.loved = item["loved"].int ?? 0
    }
    
}
