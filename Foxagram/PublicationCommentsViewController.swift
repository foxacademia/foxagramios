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
    var comment_owner_image: [Int: UIImage] = [:]
    var photo_id: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comment_table_view.delegate = self
        comment_table_view.dataSource = self
        
        comment_table_view.rowHeight = UITableViewAutomaticDimension
        comment_table_view.estimatedRowHeight = 60
        
        getComment()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.comment_table_view.reloadData()
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment_object_array.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentCellView = comment_table_view.dequeueReusableCell(withIdentifier: "CommentCellView",
                                                                           for: indexPath) as! CommentCellView
        cell.loadItem(item: comment_object_array[indexPath.row])
        getCommentOwnerImage(index: indexPath.row, url: comment_object_array[indexPath.row].owner_image, cell: cell)

  
        return cell
    }
    
    func getComment() {
        Alamofire.request( Utilities.url + "photo/\(photo_id!)/comment/get",
                           method: .get,
                           headers: Me.TOKEN ).responseJSON { response in
                            
                            if let json: JSON = JSON(response.result.value) {
                                for (_, data): (String, JSON) in json {
                                    for (_, item): (String, JSON) in data {
                                        self.comment_object_array.append(CommentObject(item: item))
                                    }
                                }
                                self.comment_table_view.reloadData()
                            }
        }

    }
    
    func getCommentOwnerImage(index: Int, url: String, cell: CommentCellView) {
        if self.comment_owner_image[index] != nil {
            cell.owner_image.image = self.comment_owner_image[index]!
            
        } else {
            cell.owner_image.imageFromUrl(url_string: url, completion: { (data) in
                self.comment_owner_image[index] = data
            })
        }

    }
}

