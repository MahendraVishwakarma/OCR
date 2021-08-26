//
//  DatePickerViewController.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 25/08/21.
//

import UIKit

class DatePickerViewController: UIViewController {
    @IBOutlet weak var datepicker: UIDatePicker!
   weak var delegate: EventAction?
    override func viewDidLoad() {
        super.viewDidLoad()
        datepicker.minimumDate = Date()
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelledButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setDateButton(_ sender: Any) {
         //let date = datepicker.date
         //delegate?.updateEvent(eventName:date)
       // self.dismiss(animated: true, completion: nil)
    }
    
}
