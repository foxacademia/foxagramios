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
    
    let identifier = "UserPhotosCell"
    let header_identifier = "UserProfileHeader"
    
    var total = "10"
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("\(Utilities.url)user/get/profile", method: .get, headers: Me.TOKEN).responseJSON { response in
            
            print(response.result.value)
            self.total = "120"
            
            
            self.collection_view.reloadData()
          
        }
        

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 120
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header_view: ProfileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: header_identifier, for: indexPath) as! ProfileHeader
        
        header_view.publications_label.text = total
        
        header_view.user_image.backgroundColor = .black
        //header_view.sectionLabel.text = dataSource.gettGroupLabelAtIndex(indexPath.section)
        
        return header_view
        
    }
    

}
