//
//  SearchResultObject.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 10/10/16.
//
//

import Foundation

class SearchResultObject {
    let name: String
    let surname: String
    let search_result_image: String
    let search_result_id: Int
    
    init(item: JSON) {
        self.name = item["names"].string ?? ""
        self.surname = item["surnames"].string ?? ""
        self.search_result_image = item["user_image"].string ?? ""
        self.search_result_id = item["id"].int ?? 0
    }
    
}
