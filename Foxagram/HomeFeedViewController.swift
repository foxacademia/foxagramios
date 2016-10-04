//
//  DashboardViewController.swift
//  Foxagram
//
//  Created by Jose Eduardo Quintero Gutiérrez on 26/09/16.
//
//

import UIKit
import Alamofire

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {
                (response: URLResponse?, data: Data?, error: Error?) -> Void in
                self.image = UIImage(data: data!)
            }
        }
    }
}

class HomeFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var home_table_view: UITableView!
    var home_object_array = [HomeObject]()
    var home_section_image: [Int: UIImage] = [:]
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
        self.home_table_view.reloadData()
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
            setOwnerImage(index: section, section: custom_home_section_view, url: url)
        }

        return custom_home_section_view
    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let height: CGFloat = 200
//        if self.home_publication_image["cell\(indexPath.section)"] != nil {
//            let image: UIImage = self.home_publication_image["cell\(indexPath.section)"]!
//            height = image.size.height
//        }
//        
//        return height
//    }
//    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomHomeCellView = home_table_view.dequeueReusableCell(withIdentifier: "CustomHomeCellView",
                                                                           for: indexPath) as! CustomHomeCellView
        cell.loadCell(item: home_object_array[indexPath.section])
    //    cell.publication_description.text = "section \(indexPath.section)"
        setOwnerPublication(index: "cell\(indexPath.section)", cell: cell, url: cell.publication_url)
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touched")
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
    
    func setOwnerImage(index: Int, section: CustomHomeSectionView, url: String) {
        if self.home_section_image[index] != nil {
            section.owner_image.image = self.home_section_image[index]!
            
        } else {
            section.owner_image.imageFromUrl(urlString: url)
        }
    }
    
    func setOwnerPublication(index: String, cell: CustomHomeCellView, url: String) {
        if self.home_publication_image[index] != nil {
            cell.publication_image.image = self.home_publication_image[index]!
            
        } else {
            cell.publication_image.imageFromUrl(urlString: url)
            self.home_publication_image[index] = cell.publication_image.image
        }
    }
    
//    function for scale images
//    func imageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
//        let oldWidth = sourceImage.size.width
//        let scaleFactor = scaledToWidth / oldWidth
//        
//        let newHeight = sourceImage.size.height * scaleFactor
//        let newWidth = oldWidth * scaleFactor
//        
//        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
//        sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage!
//    }

}
