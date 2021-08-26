//
//  CaseViewController.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 25/08/21.
//

import UIKit

class CaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func caseA(_ sender: Any) {
        guard let obj = self.storyboard?.instantiateViewController(withIdentifier: "EventsViewController") else { return  }
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func caseB(_ sender: Any) {
        guard let obj = self.storyboard?.instantiateViewController(withIdentifier: "OCRViewController") else { return  }
        self.navigationController?.pushViewController(obj, animated: true)
    }
}
