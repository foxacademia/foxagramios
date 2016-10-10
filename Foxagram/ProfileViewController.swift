//
//  ProfileViewController.swift
//  Foxagram
//
//  Created by Jose Eduardo Quintero Gutiérrez on 03/10/16.
//
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collection_view: UICollectionView!
    var publications_array: [PublicationObject] = [PublicationObject]()
    
    let identifier = "UserPhotosCell"
    let header_identifier = "UserProfileHeader"
    
    var followers: String!
    var following: String!
    
    var publication_images: [String: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("\(Utilities.url)user/get/profile", method: .get, headers: Me.TOKEN).responseJSON { response in
            
            let json:JSON = JSON(response.result.value)
            
            for (_, subJson): (String, JSON) in json["profile"] {
                self.followers = subJson["followers"].string ?? "0"
                self.following = subJson["following"].string ?? "0"
            }
            
            for (_, subJson): (String, JSON) in json["photos"] {
                let photo_id = subJson["id"].int!
                let photo_name = subJson["file_name"].string!
                let owner_id = subJson["user_id"].int!

                let publication_object = PublicationObject(photo_id: photo_id, photo_name: photo_name, owner_image: "", owner: "", owner_id: owner_id)
                
                self.publications_array.append(publication_object)
            }
            
            self.collection_view.reloadData()
          
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return publications_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ProfileViewCell

        if !publications_array.isEmpty {
            let publication_object = publications_array[indexPath.row] as PublicationObject
            //setOwnerPublication(index: indexPath.row, image_view: cell.publication_image, url: publication_object.photo_url)
            
            if (self.publication_images[identifier] != nil){
                let image_saved : UIImage = self.publication_images[identifier]!
                cell.publication_image.image = image_saved
            } else {
                cell.publication_image.imageFromUrl(url_string: publication_object.photo_url, completion: { (data) in
                    self.publication_images[self.identifier] = data
                })
            }

            cell.backgroundColor = .red
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header_view: ProfileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: header_identifier, for: indexPath) as! ProfileHeader
        
        header_view.followers_label.text = followers
        header_view.following_label.text = following
        header_view.publications_label.text = "\(publications_array.count)"

        header_view.user_image.backgroundColor = .black
        //header_view.sectionLabel.text = dataSource.gettGroupLabelAtIndex(indexPath.section)
        
        return header_view
        
    }
  

}
