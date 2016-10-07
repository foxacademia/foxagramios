//
//  PublicationObject.swift
//  Foxagram
//
//  Created by Jose Eduardo Quintero Gutiérrez on 06/10/16.
//
//

import Foundation

class PublicationObject: NSObject {
    let owner_id: Int
    let owner: String
    let owner_image: String
    let photo_id: Int
    let photo_title: String
    let photo_url: String
    
    init(item: JSON){
        self.owner_id = item["user_id"].int!
        self.owner = item["names"].string ?? ""
        self.owner_image = item["user_image"].string ?? ""
        self.photo_id = item["photo_id"].int!
        self.photo_title = item["photo_title"].string ?? ""
        self.photo_url = item["photo_url"].string ?? ""
    }
    
    init(photo_id: Int, photo_name: String, owner_image: String, owner: String, owner_id: Int){
        self.photo_id = photo_id
        self.photo_url = Utilities.photo_url + "\(owner_id)/\(photo_name)"
        self.owner_image = owner_image
        self.owner = owner;
        
        self.owner_id = 0
        self.photo_title = ""
        
    }
}
