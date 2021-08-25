//
//  AddEventViewController.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 25/08/21.
//

import UIKit

class AddEventViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var descriptionView: UITextView!
    var viewModel: AddEventViewModel?
    @IBOutlet weak var txtDatePicker: UITextField!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProps()
        showDatePicker()
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Set Date", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy ⏰ hh:MM:ss"
        let eventDate =  formatter.string(from: datePicker.date)
        txtDatePicker.text = eventDate
        viewModel?.event?.date = eventDate
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    private func setViewProps() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        txtTitle.delegate = self
        descriptionView.layer.borderWidth = 0.5
        descriptionView.layer.borderColor = UIColor.black.cgColor
        viewModel = AddEventViewModel()
    }
    @IBAction func addEvent(_ sender: Any) {
        if((txtTitle.text?.count ?? 0) <= 0) {
            showAlert(title: "Missing Title", details: "Please enter title")
            return
        }
        if(viewModel?.event?.date == nil) {
            showAlert(title: "Missing Event Date", details: "Please set date")
            return
        }
        viewModel?.event?.title =  txtTitle.text
        viewModel?.event?.eventDescription = descriptionView.text ?? ""
        viewModel?.addEventInLocalStorage()
        viewModel?.setReminderInSystem()
    }
    
    @IBAction func openCalender(_ sender: Any) {
        //let obj = DatePickerViewController(nibName:"DatePickerViewController",bundle: nil)
        //obj.modalPresentationStyle = .fullScreen
        //self.present(obj, animated: true, completion: nil)
        //self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
