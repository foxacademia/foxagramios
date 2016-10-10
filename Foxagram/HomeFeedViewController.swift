//
//  DashboardViewController.swift
//  Foxagram
//
//  Created by Jose Eduardo Quintero Gutiérrez on 26/09/16.
//
//
import Foundation
import UIKit
import Alamofire

extension UIImageView {
    public func imageFromUrl(url_string: String, completion: @escaping (_ data: UIImage?) -> Void) {
        if let url = URL(string: url_string) {
            let request = NSMutableURLRequest(url: url)
            let session = URLSession.shared
            request.httpMethod = "GET"
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
                self.image = UIImage(data: data!)
                completion(self.image)
            })
            
            task.resume()

        }
    }
}

class HomeFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var home_table_view: UITableView!
    var home_object_array = [HomeObject]()
    var home_section_image: [String: UIImage] = [:]
    var home_publication_image: [String: UIImage] = [:]
    var cell_index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        home_table_view.delegate = self
        home_table_view.dataSource = self
        
        home_table_view.rowHeight = UITableViewAutomaticDimension
        home_table_view.estimatedRowHeight = 44
        
        getHome()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      //  self.home_table_view.reloadData()
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return home_object_array.count
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var custom_home_section_view: CustomHomeSectionView = CustomHomeSectionView()
        custom_home_section_view = (Bundle.main.loadNibNamed("CustomHomeSectionView", owner: self, options: nil)![0] as? CustomHomeSectionView)!
        if !home_object_array.isEmpty {
            custom_home_section_view.loadHeader(home_item: home_object_array[section])
            let url: String = home_object_array[section].owner_image
            setOwnerImage(index: "\(section)", section: custom_home_section_view, url: url)
        }

        return custom_home_section_view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomHomeCellView = home_table_view.dequeueReusableCell(withIdentifier: "CustomHomeCellView",
                                                                           for: indexPath) as! CustomHomeCellView
        cell.loadCell(item: home_object_array[indexPath.section])
    //    cell.publication_description.text = "section \(indexPath.section)"
        cell.publication_image.alpha = 0
        setOwnerPublication(index: "cell\(indexPath.section)", cell: cell, url: cell.publication_url)
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view_controller = self.storyboard!.instantiateViewController(withIdentifier: "PublicationCommentsViewController") as! PublicationCommentsViewController
        view_controller.photo_id = home_object_array[indexPath.section].photo_id
        self.navigationController?.pushViewController(view_controller, animated: true)
    }
    
    func getHome() {
        Alamofire.request( Utilities.url,
                           method: .get,
                           headers: Me.TOKEN ).responseJSON { response in
                            
            if let json: JSON = JSON(response.result.value) {
                for (_, subJson): (String, JSON) in json {
                    self.home_object_array.append(HomeObject(item: subJson))
                }
                self.home_table_view.reloadData()
            }
        }
    }
    
    func setOwnerImage(index: String, section: CustomHomeSectionView, url: String) {
        if self.home_section_image[index] != nil {
            section.owner_image.image = self.home_section_image[index]!
            
        } else {
            section.owner_image.imageFromUrl(url_string: url, completion: { (data) in
                    self.home_section_image[index] = data
            })
            
        }
    }
    
    func setOwnerPublication(index: String, cell: CustomHomeCellView, url: String) {
        if self.home_publication_image[index] != nil {
            cell.publication_image.image = self.home_publication_image[index]!
            cell.publication_image.alpha = 1
        } else {
            cell.publication_image.imageFromUrl(url_string: url, completion: { (data) in
                if data == nil { cell.publication_image.image = UIImage(named: "sad_error") }
                else { self.home_publication_image[index] = data }
                cell.publication_image.alpha = 1
            })
        }
    }

}
