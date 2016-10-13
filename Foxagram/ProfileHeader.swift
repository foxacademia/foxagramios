//
//  ProfileHeader.swift
//  Foxagram
//
//  Created by Jose Eduardo Quintero Gutiérrez on 03/10/16.
//
//

import UIKit
import Alamofire

class ProfileHeader: UICollectionReusableView {
        
    @IBOutlet var publications_label: UILabel!
    @IBOutlet var followers_label: UILabel!
    @IBOutlet var following_label: UILabel!
    @IBOutlet weak var follow_button: UIButton!
    
    @IBOutlet var user_name_label: UILabel!
    @IBOutlet var user_image: UIImageView!
    var user_id: Int!
    
    @IBAction func setFollow(_ sender: UIButton) {
        let params: [String: Int] = [ "user_id": self.user_id ]
        Alamofire.request( Utilities.url + "user/follow/set",
                           method: .post,
                           parameters: params,
                           headers: Me.TOKEN ).responseJSON { response in
                            
                            if let json: JSON = JSON(response.result.value) {
                                if json["data"].string! == "following" {
                                    self.follow_button.layer.borderWidth = 0
                                    self.follow_button.backgroundColor = Utilities.accent_color
                                    self.follow_button.setTitle("FOLLOWING", for: UIControlState.normal)
                                    self.follow_button.setTitleColor(UIColor.white, for: UIControlState.normal)
                                } else if json["data"].string! == "unfollow" {
                                    self.follow_button.layer.borderWidth = 1
                                    self.follow_button.layer.borderColor = Utilities.accent_color.cgColor
                                    self.follow_button.backgroundColor = UIColor.white
                                    self.follow_button.setTitle("FOLLOW", for: UIControlState.normal)
                                    self.follow_button.setTitleColor(Utilities.accent_color, for: UIControlState.normal)
                                }
                            }
        }

    }
    
    
}
