//
//  TabBarController.swift
//  Foxagram
//
//  Created by Jose Eduardo Quintero Gutiérrez on 07/10/16.
//
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if self.selectedIndex == 3{
            print("SOY EL TAG 2")
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(viewController.restorationIdentifier)
            if viewController.restorationIdentifier == "CameraTab"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let cameraViewController = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
                present(cameraViewController, animated: true, completion: nil)
                return false
            }
        return true
    }

}
