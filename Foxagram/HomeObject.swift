//
//  HomeObject.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 9/28/16.
//
//

import Foundation

class HomeObject: NSObject {
    let owner: String
    let owner_image: String
    let photo_url: String
    let photo_title: String
    let date: String
    let loved: Int
    
    init(item: JSON) {
        self.owner = item["names"].string ?? ""
        self.owner_image = item["user_image"].string ?? ""
        self.photo_url = item["photo_url"].string ?? ""
        self.photo_title = item["title"].string ?? ""
        self.date = item["date"].string ?? ""
        self.loved = item["loved"].int ?? 0
    }
    
}
