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

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var home_table_view: UITableView!
    var home_object_array = [HomeObject]()
    var home_section_image: [Int: UIImage] = [:]
    var cell_index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        home_table_view.delegate = self
        home_table_view.dataSource = self
        
        getHome()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.textLabel?.text = "hue \(home_object_array[self.cell_index].photo_title)"
        cell_index += 1
        return cell
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
                self.cell_index = 0
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
    

}
