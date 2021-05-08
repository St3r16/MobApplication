//
//  UIViewController.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/4/21.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach { (aa) in
            ac.addAction(aa)
        }
        
        self.present(ac, animated: true, completion: nil)
    }
    
    func showAlert(error: Error) {
        self.showAlert(title: "Ooops!",
                       message: error.localizedDescription,
                       actions: [UIAlertAction(title: "Ok", style: .cancel, handler: nil)])
    }
    
}

