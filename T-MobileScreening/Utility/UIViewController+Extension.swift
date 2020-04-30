//
//  UIViewController+Extension.swift
//  T-MobileScreening
//
//  Created by Tanay Kumar Roy on 4/30/20.
//  Copyright © 2020 Tanay Kumar Roy. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(message: String) {
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
