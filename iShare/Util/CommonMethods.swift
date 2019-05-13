//
//  CommonMethods.swift
//  iShare
//
//  Created by Shafeer Puthalan on 12/05/19.
//  Copyright © 2019 Shafeer Puthalan. All rights reserved.
//

import Foundation
import UIKit


class CommonMethods {
    static func showAlert(title : String, message : String, view : UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        view.present(alertController, animated: true, completion: nil)
    }
}
