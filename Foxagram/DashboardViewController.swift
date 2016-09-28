//
//  DashboardViewController.swift
//  Foxagram
//
//  Created by Jose Eduardo Quintero Gutiérrez on 26/09/16.
//
//

import UIKit
import Alamofire

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var home_table_view: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        let params = [ "user_id": 3]
        
        print("DID APPEAR")
        
        Alamofire.request(Utilities.url ,method: .get, parameters: params, headers: Me.TOKEN).responseJSON { response in
            if let json :JSON = JSON(response.result.value) {
                print("JSON: \(json)")
            }
        }

    }

}
