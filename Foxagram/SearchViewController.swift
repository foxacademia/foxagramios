//
//  SearchViewController.swift
//  Foxagram
//
//  Created by Edgar Allan Glez on 10/10/16.
//
//

import Foundation
import UIKit
import Alamofire

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var search_table_view: UITableView!
    @IBOutlet weak var search_text_body: UITextField!
    
    var search_object_array = [SearchResultObject]()
    var search_result_image_array: [Int: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardTappedAround()
        
        search_table_view.delegate = self
        search_table_view.dataSource = self
        
        search_table_view.rowHeight = UITableViewAutomaticDimension
        search_table_view.estimatedRowHeight = 60
        
        search_text_body.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search_object_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCellView = search_table_view.dequeueReusableCell(withIdentifier: "SearchCellView",
                                                                           for: indexPath) as! SearchCellView
        cell.loadItem(item: search_object_array[indexPath.row])
        cell.search_result_image.alpha = 0
        getSearchResultImage(index: indexPath.row, url: search_object_array[indexPath.row].search_result_image, cell: cell)
        
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        getSearch(text: textField.text!)
        return true
    }
    
    func getSearch(text: String) {
        search_object_array.removeAll()
        search_result_image_array.removeAll()
        Alamofire.request( Utilities.url + "user/search/\(text)",
                           method: .get,
                           headers: Me.TOKEN ).responseJSON { response in
                            
                            if let json: JSON = JSON(response.result.value) {
                                for (_, subJson): (String, JSON) in json {
                                    self.search_object_array.append(SearchResultObject(item: subJson))
                                }
                                self.search_table_view.reloadData()
                            }
        }
        
    }
    
    func getSearchResultImage(index: Int, url: String, cell: SearchCellView) {
        if self.search_result_image_array[index] != nil {
            cell.search_result_image.image = self.search_result_image_array[index]!
            cell.search_result_image.alpha = 1
            
        } else {
            cell.search_result_image.imageFromUrl(url_string: url, completion: { (data) in
                if data == nil {
                    cell.search_result_image.image = UIImage(named: "sad_error")
                    self.search_result_image_array[index] = UIImage(named: "sad_error")
                }
                else { self.search_result_image_array[index] = data }
                cell.search_result_image.alpha = 1
                
            })
        }
    }
}
