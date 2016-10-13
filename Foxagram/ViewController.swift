//
//  ViewController.swift
//  Foxagram
//
//  Created by Jose Eduardo Quintero Gutiérrez on 21/09/16.
//
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()


        if FBSDKAccessToken.current() != nil{
           getFBUserData()
        }else{
            print("Not logged in")
        }
        
        let background = Utilities.Colors
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email"]
        loginButton.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - 50)

        loginButton.delegate = self

        self.view.addSubview(loginButton)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    //FBSDK
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        if error == nil{
            getFBUserData()
        }else{
            print(error.localizedDescription)
        }
    }

    func getFBUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, middle_name, last_name, email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in

            if ((error) != nil) {
                print("Error")
            } else {
                let json: JSON = JSON(result)
                let facebook_key = json["id"].string!
                let middle_name = json["middle_name"].string ?? ""
                let names = "\(json["first_name"].string!) \(middle_name)"
                let surnames = json["last_name"].string!
                let email = json["email"].string ?? ""


                let params:[String: String] = [
                    "facebook_key" : facebook_key,
                    "names" : names,
                    "surnames": surnames,
                    "email": email,
                    "user_image": "https://graph.facebook.com/\(json["id"].string!)/picture?type=normal"]

                Alamofire.request("\(Utilities.url)auth/login", method: .post, parameters: params).validate().responseJSON { response in
                    switch response.result {
                    case .success:
                        if let json :JSON = JSON(response.result.value) {
                            print(response.result.value)
                            Me.init(item: json)
                            
                            self.performSegue(withIdentifier: "init", sender: self)
                        }
                    case .failure:
                        print("Error")
                    }
                }
            }
        })
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }


}
