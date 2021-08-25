//
//  BaseViewController.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 25/08/21.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showAlert(title:String?, details:String?, style:UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: details, preferredStyle: style)
        let ok = UIAlertAction(title: "OK", style: .default) { (alt) in
            alert.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

}
