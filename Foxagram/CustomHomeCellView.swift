//
//  CustomHomeCellView.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 9/30/16.
//
//

import Foundation
import UIKit
import Alamofire

class CustomHomeCellView: UITableViewCell {
    
    
    @IBOutlet weak var publication_date: UILabel!
    @IBOutlet weak var publication_owner: UILabel!
    @IBOutlet weak var publication_description: UILabel!
    @IBOutlet weak var publication_image: UIImageView!
    @IBOutlet weak var love_icon: UIImageView!
    @IBOutlet weak var comment_icon: UIImageView!
    
    var parent_view_controller: HomeFeedViewController!
    var publication_url: String!
    var photo_id: Int!
    
    func loadCell(item: HomeObject, parent_view_controller: HomeFeedViewController) {
        self.parent_view_controller = parent_view_controller
        publication_url = Utilities.photo_url + "\(item.owner_id)/\(item.photo_name!)"
        publication_owner.text = item.owner
        publication_description.text = item.photo_title
        photo_id = item.photo_id
        
        let tap_comments = UITapGestureRecognizer(target: self, action: #selector(self.goToComments(_:)))
        self.comment_icon.addGestureRecognizer(tap_comments)
        self.comment_icon.isUserInteractionEnabled = true
        
        let tap_love = UITapGestureRecognizer(target: self, action: #selector(self.loveImage(_:)))
        self.love_icon.addGestureRecognizer(tap_love)
        self.love_icon.isUserInteractionEnabled = true
        
        let double_tap_love = UITapGestureRecognizer(target: self, action: #selector(self.loveImage(_:)))
        self.publication_image.addGestureRecognizer(double_tap_love)
        double_tap_love.numberOfTapsRequired = 2
        self.publication_image.isUserInteractionEnabled = true
    }
    
    func loveImage(_ goToComments: UITapGestureRecognizer){
        self.heartAnimation(container: self.publication_image)
        
        let params = ["photo_id": self.photo_id]
        Alamofire.request("\(Utilities.url)photo/like",
            method: .post,
            parameters: params).validate().responseJSON { response in
                switch response.result {
                case .success:
                    if let json :JSON = JSON(response.result.value) {
                        print(response.result.value)
                    }
                case .failure:
                    print("Error")
                }
        }
        
    }
    
    func goToComments(_ goToComments: UITapGestureRecognizer){
        let view_controller = parent_view_controller.storyboard!.instantiateViewController(withIdentifier: "PublicationCommentsViewController") as! PublicationCommentsViewController
        view_controller.photo_id = self.photo_id
        parent_view_controller.navigationController?.pushViewController(view_controller, animated: true)
        
    }
    
    func heartAnimation(container: UIImageView) -> Void{
        let heart_image: UIImageView = UIImageView(frame: CGRect(x: 0.0, y:0.0, width: container.frame.width, height: container.frame.height))
        heart_image.tintColor = UIColor.white
        heart_image.image = UIImage(named: "heart_filled_icon")
        heart_image.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        container.addSubview(heart_image)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3,  animations: {
            heart_image.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            }, completion: { finish in
                UIView.animate(withDuration: 0.2, animations: {
                    heart_image.alpha = 0
                    heart_image.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    }, completion: { finish in
                        heart_image.removeFromSuperview()
                })
        })
        
    }
    
    

}
