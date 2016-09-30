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
        
        Alamofire.request("http://0.0.0.0:3000/user/2/follow" ,method: .post, parameters: params,headers: Me.headers).responseJSON { response in
            
            if let json :JSON = JSON(response.result.value){
                print("Following \(json)")
            }
            
        }

    }
    

}
