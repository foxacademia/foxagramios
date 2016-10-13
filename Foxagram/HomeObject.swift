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
    let photo_name: String?
    let photo_id: Int
    let photo_title: String
    var loved: Bool
    var loves: Int
    let photo_url: String
    
    init(item: JSON) {
        self.owner_id = item["user_id"].int!
        self.owner = item["names"].string ?? ""
        self.owner_image = item["user_image"].string ?? ""
        self.photo_name = item["file_name"].string ?? ""
        self.photo_id = item["photo_id"].int ?? 0
        self.photo_title = item["title"].string ?? ""
        self.loved = item["loved"].bool ?? false
        self.photo_url = Utilities.photo_url + "\(owner_id)/\(photo_name)"
        self.loves = item["loves"].int ?? 0
    }
    
    init(photo_id: Int, photo_name: String, owner_image: String, owner: String, owner_id: Int, photo_title: String, loved: Bool, loves: Int){
        self.photo_id = photo_id
        self.owner_id = owner_id
        self.photo_url = Utilities.photo_url + "\(owner_id)/\(photo_name)"
        self.owner_image = owner_image
        self.owner = owner;
        self.photo_title = photo_title
        self.loved = loved
        self.loves = loves
        
        self.photo_name = nil
        
    }
    
    func setLove(value: Bool){
        if value == true{
            self.loved = true
        }else{
            self.loved = false
        }
    }
    
}
