//
//  PublicationDetailViewController.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 10/4/16.
//
//

import Foundation
import UIKit
import Alamofire

class PublicationDetailViewController: UIViewController {
    
    @IBOutlet weak var publication_image: UIImageView!
    @IBOutlet weak var owner_image: UIImageView!
    @IBOutlet weak var owner_name: UILabel!
    @IBOutlet var photo_title: UILabel!
    @IBOutlet var owner_name_title: UILabel!
    
    @IBOutlet var comments_image: UIImageView!
    @IBOutlet var love_image: UIImageView!
    var publication_image_value: UIImage!
    var owner_name_value: String!
    var owner_image_url: String!
    var photo_title_value: String!
    var photo_id: Int!
    
    func loadPublicationDetail() {
        
    }
    
    override func viewDidLoad() {
        publication_image.image = publication_image_value
        owner_name.text = owner_name_value
        photo_title.text = photo_title_value
        owner_name_title.text = owner_name_value
        
        Alamofire.request(owner_image_url).responseImage { response in
            if let image = response.result.value{
                self.owner_image.image = image
            }

        }
        
        let tap_comments = UITapGestureRecognizer(target: self, action: #selector(PublicationDetailViewController.goToComments(_:)))
        self.comments_image.addGestureRecognizer(tap_comments)
        self.comments_image.isUserInteractionEnabled = true
        
        let tap_love = UITapGestureRecognizer(target: self, action: #selector(PublicationDetailViewController.loveImage(_:)))
        self.love_image.addGestureRecognizer(tap_love)
        self.love_image.isUserInteractionEnabled = true
        
        let double_tap_love = UITapGestureRecognizer(target: self, action: #selector(PublicationDetailViewController.loveImage(_:)))
        self.publication_image.addGestureRecognizer(double_tap_love)
        double_tap_love.numberOfTapsRequired = 2
        self.publication_image.isUserInteractionEnabled = true
        
    }
    func goToComments(_ goToComments: UITapGestureRecognizer){
        let view_controller = self.storyboard!.instantiateViewController(withIdentifier: "PublicationCommentsViewController") as! PublicationCommentsViewController
        view_controller.photo_id = self.photo_id
        self.navigationController?.pushViewController(view_controller, animated: true)

    }
    
    func loveImage(_ goToComments: UITapGestureRecognizer){
        self.heartAnimation(container: self.publication_image)
        
        let params = ["photo_id": self.photo_id]
        Alamofire.request("\(Utilities.url)photo/like", method: .post, parameters: params).validate().responseJSON { response in
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
