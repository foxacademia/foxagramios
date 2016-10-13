//
//  Utilities.swift
//  Foxagram
//
//  Created by Jose Eduardo Quintero Gutiérrez on 26/09/16.
//
//

import Foundation
import UIKit

class Utilities: NSObject {
    static var url = "http://192.168.1.243:3000/"
    static var photo_url = "http://45.55.7.118/photos/"

    class var Colors: CAGradientLayer {
        let colorBottom = UIColor(red: 124.0/255.0, green: 86.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor
        let colorTop = UIColor(red: 91.0/255.0, green: 199.0/255.0, blue: 254.0/255.0, alpha: 1.0).cgColor

        let gl: CAGradientLayer

        gl = CAGradientLayer()
        gl.colors = [ colorTop, colorBottom]
        gl.locations = [ 0.0, 1.0 ]

        return gl
    }

    class var accent_color: UIColor {
       return UIColor(red: 33.0/255.0, green: 150.0/255.0, blue: 243.0/255.0, alpha: 1.0)
    }
}
