//
//  ProfileViewController.swift
//  Foxagram
//
//  Created by Jose Eduardo Quintero Gutiérrez on 03/10/16.
//
//

import UIKit
import Alamofire
import AlamofireImage

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collection_view: UICollectionView!
    var publications_array: [HomeObject] = [HomeObject]()
    let identifier = "UserPhotosCell"
    let header_identifier = "UserProfileHeader"
    var following: Bool = false
    var followers: Int = 0
    var followings: Int = 0
    var user_image_url: String = ""
    var user_name: String = ""
    var user_id: Int = 0
    var frame_width: CGFloat!
    var cell_size: CGFloat = 100.0
    var publication_images: [String: UIImage] = [:]


    override func viewDidLoad() {
        super.viewDidLoad()

        if user_id == 0 { user_id = Me.USER_ID }
        Alamofire.request("\(Utilities.url)user/get/profile/\(user_id)", method: .get, headers: Me.TOKEN).responseJSON { response in

            let json:JSON = JSON(response.result.value)

            print(json)
            self.followers = json["profile"][0]["followers"].int ?? 0
            self.followings = json["profile"][0]["followings"].int ?? 0
            self.following = json["profile"][0]["following"].bool ?? false

            self.user_image_url = json["user_info"]["user_image"].string ?? ""
            self.user_name = json["user_info"]["names"].string ?? ""


            for (_, subJson): (String, JSON) in json["photos"] {
                let photo_id = subJson["id"].int!
                let photo_name = subJson["file_name"].string!
                let owner_id = subJson["user_id"].int!
                let photo_title = subJson["title"].string!
                let loves = subJson["loves"].int!
                let loved = subJson["loved"].bool!

                let publication_object = HomeObject(photo_id: photo_id, photo_name: photo_name, owner_image: "", owner: "", owner_id: owner_id, photo_title: photo_title, loved: loved, loves: loves)

                self.publications_array.append(publication_object)
            }
            self.collection_view.reloadData()
        }


    }

    override func viewDidAppear(_ animated: Bool) {
        self.collection_view.reloadData()
        frame_width = self.collection_view.frame.size.width
        cell_size = (self.frame_width / 3) - 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {

        return CGSize(width: cell_size, height: cell_size)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return publications_array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ProfileViewCell
        let cell_identifier = "Cell\(indexPath.row)"

        if !publications_array.isEmpty {
            cell.publication_image.alpha = 0

            let publication_object = publications_array[indexPath.row] as HomeObject
            //setOwnerPublication(index: indexPath.row, image_view: cell.publication_image, url: publication_object.photo_url)

            if (self.publication_images[cell_identifier] != nil){
                let image_saved : UIImage = self.publication_images[cell_identifier]!
                cell.publication_image.image = image_saved
                cell.publication_image.alpha = 1
            } else {

                Alamofire.request(publication_object.photo_url).responseImage { response in

                    if let image = response.result.value {
                        cell.publication_image.image = image
                        self.publication_images[cell_identifier] = image
                    } else {
                        cell.publication_image.image = UIImage(named: "sad_error")
                        self.publication_images[cell_identifier] = cell.publication_image.image
                    }
                    cell.publication_image.alpha = 1
                }
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header_view: ProfileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: header_identifier, for: indexPath) as! ProfileHeader

        header_view.user_id = self.user_id
        header_view.followers_label.text = "\(followers)"
        header_view.following_label.text = "\(followings)"
        header_view.publications_label.text = "\(publications_array.count)"
        header_view.user_name_label.text = "\(user_name)"
        
        if self.following {
            header_view.follow_button.layer.borderWidth = 0
            header_view.follow_button.backgroundColor = Utilities.accent_color
            header_view.follow_button.setTitle("FOLLOWING", for: UIControlState.normal)
            header_view.follow_button.setTitleColor(UIColor.white, for: UIControlState.normal)
        } else {
            header_view.follow_button.layer.borderWidth = 1
            header_view.follow_button.layer.borderColor = Utilities.accent_color.cgColor
            header_view.follow_button.layer.cornerRadius = 3
            header_view.follow_button.backgroundColor = UIColor.white
            header_view.follow_button.setTitleColor(Utilities.accent_color, for: UIControlState.normal)
        }

   

        Alamofire.request(self.user_image_url).responseImage { response in
            if let image = response.result.value{
                header_view.user_image.image = image
            }
        }
        //header_view.sectionLabel.text = dataSource.gettGroupLabelAtIndex(indexPath.section)
        return header_view

    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let view_controller = self.storyboard!.instantiateViewController(withIdentifier: "PublicationDetailViewController") as! PublicationDetailViewController
        //view_controller.photo_id = publications_array[indexPath.row].photo_id
        let profile_cell = collectionView.cellForItem(at: indexPath) as! ProfileViewCell

        view_controller.publication_image_value = profile_cell.publication_image.image
        view_controller.owner_name_value = publications_array[indexPath.row].owner
        view_controller.owner_name_value = self.user_name
        view_controller.owner_image_url = self.user_image_url
        view_controller.photo_title_value = publications_array[indexPath.row].photo_title
        view_controller.photo_id = publications_array[indexPath.row].photo_id
        view_controller.loved = publications_array[indexPath.row].loved

        //view_controller.owner_image.image =

        self.navigationController?.pushViewController(view_controller, animated: true)
    }

}
