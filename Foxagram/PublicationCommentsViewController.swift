//
//  PublicationCommentsViewController.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 10/5/16.
//
//

import UIKit
import Alamofire

extension UIViewController {
    func hideKeyboardTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class PublicationCommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var comment_table_view: UITableView!
    @IBOutlet weak var text_bottom_constraint: NSLayoutConstraint!
    @IBOutlet weak var comment_textfield: UITextField!
  
    var comment_object_array = [CommentObject]()
    var comment_owner_image: [Int: UIImage] = [:]
    var photo_id: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        comment_table_view.delegate = self
        comment_table_view.dataSource = self
        
        comment_table_view.rowHeight = UITableViewAutomaticDimension
        comment_table_view.estimatedRowHeight = 60
        
        comment_textfield.layer.borderColor = UIColor.lightGray.cgColor
        
        getComment()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.comment_table_view.reloadData()
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 2, animations: { () -> Void in
            self.text_bottom_constraint.constant = (keyboardFrame.size.height - 45) * -1
        })
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 1.2, animations: { () -> Void in
            self.text_bottom_constraint.constant = -5
        })
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment_object_array.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentCellView = comment_table_view.dequeueReusableCell(withIdentifier: "CommentCellView",                                                                                                             for: indexPath) as! CommentCellView
        cell.loadItem(item: comment_object_array[indexPath.row])
        getCommentOwnerImage(index: indexPath.row, url: comment_object_array[indexPath.row].owner_image, cell: cell)

        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = [UITableViewRowAction]()
        let action = UITableViewRowAction(style: .normal, title: "(:") { action, index in
        }
        action.backgroundColor = UIColor.lightGray
        actions.append(action)
        if self.comment_object_array[indexPath.row].owner_id == Me.USER_ID {
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
                self.deleteComment(index: index.last!)
                tableView.setEditing(false, animated: true)
                self.comment_object_array.remove(at: indexPath.row)
                self.comment_table_view.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            }
            
            delete.backgroundColor = UIColor.red
            actions.insert(delete, at: 0)
        }
        
        return actions
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("hey")
        // you need to implement this method too or you can't swipe to display the actions
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
    
    @IBAction func post_comment(_ sender: UIButton) {
        let comment = self.comment_textfield.text ?? ""
        let params: [String : Any] = [ "comment_body": comment,
                                       "photo_id": self.photo_id ]
        Alamofire.request( Utilities.url + "photo/comment/new",
            method: .post,
            parameters: params,
            headers: Me.TOKEN ).responseJSON { response in
                
                if let json: JSON = JSON(response.result.value) {
                    self.comment_textfield.text = ""
                    let last_comment = CommentObject(item: json)
                    last_comment.owner_image = Me.PROFILE_IMAGE
                    last_comment.owner = Me.NAME
                    self.comment_object_array.append(last_comment)
                    self.comment_table_view.reloadData()
            
                    self.comment_table_view.scrollToRow(at: IndexPath(row: self.comment_object_array.count - 1, section: 0),
                                                        at: UITableViewScrollPosition.bottom,
                                                        animated: true)
                    
                }
        }
        
    }
    
    func deleteComment(index: Int) {
        
        let params: [String: Int] = [ "comment_id": self.comment_object_array[index].comment_id ]
        Alamofire.request( Utilities.url + "photo/comment/delete",
                           method: .put,
                           parameters: params,
                           headers: Me.TOKEN ).responseJSON { response in
        
                            if let json: JSON = JSON(response.result.value) {
                                self.comment_table_view.reloadData()
                            }
        }

    }
    
}

