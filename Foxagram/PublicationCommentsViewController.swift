//
//  PublicationCommentsViewController.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 10/5/16.
//
//

import UIKit
import Alamofire

class PublicationCommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var comment_table_view: UITableView!
    var comment_object_array = [CommentObject]()
    let photo_id: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comment_table_view.delegate = self
        comment_table_view.dataSource = self
        
        
        comment_table_view.rowHeight = UITableViewAutomaticDimension
        comment_table_view.estimatedRowHeight = 60
        
        
        getComment()
        
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment_object_array.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomHomeCellView = comment_table_view.dequeueReusableCell(withIdentifier: "CommentCellView",
                                                                           for: indexPath) as! CustomHomeCellView
//        cell.loadCell(item: home_object_array[indexPath.section])
        //    cell.publication_description.text = "section \(indexPath.section)"
//        setOwnerPublication(index: "cell\(indexPath.section)", cell: cell, url: cell.publication_url)
        
        return cell
    }
    
    func getComment() {
        Alamofire.request( Utilities.url + "/\(photo_id)/comment/get",
                           method: .get,
                           headers: Me.TOKEN ).responseJSON { response in
                            
                            if let json: JSON = JSON(response.result.value) {
                                for (_, subJson): (String, JSON) in json {
                                    self.comment_object_array.append(CommentObject(item: subJson))
                                }
                                self.comment_table_view.reloadData()
                            }
        }

    }
    
    
}

