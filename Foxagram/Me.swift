//
//  Me.swift
//  Foxagram
//
//  Created by Jose Eduardo Quintero Gutiérrez on 26/09/16.
//
//

import UIKit

class Me: NSObject {
    static var TOKEN: [String: String] = [:]
    static var PROFILE_IMAGE: String!
    static var NAME: String!
    static var SURNAME: String!
    static var USER_ID: Int!
    
    static func `init`(item: JSON) {
        self.TOKEN = [ "Authorization": "\(item["token"].string!)" ]
        self.PROFILE_IMAGE = item["user"]["user_image"].string!
        self.NAME = item["user"]["names"].string!
        self.SURNAME = item["user"]["surnames"].string!
        self.USER_ID = item["user"]["id"].int!
    }
}
