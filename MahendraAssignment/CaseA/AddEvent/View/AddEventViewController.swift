//
//  AddEventViewController.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 25/08/21.
//

import UIKit

class AddEventViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var btnAddEvent: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var descriptionView: UITextView!
    var viewModel: AddEventViewModel?
    
    @IBOutlet weak var txtDatePicker: UITextField!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProps()
        showDatePicker()
        setDefaultValue()
    }
    private func setDefaultValue() {
        
        txtTitle.text = viewModel?.event?.title
        descriptionView.text = viewModel?.event?.eventDescription
        txtDatePicker.text = viewModel?.event?.date
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = .white
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
           
        }
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
        formatter.dateFormat = "dd-MM-yyyy ⏰ hh:mm a"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        let eventDate =  formatter.string(from: datePicker.date)
        txtDatePicker.text = eventDate
        viewModel?.event?.date = eventDate
        viewModel?.event?.eventDate = datePicker.date
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    private func setViewProps() {
        if(viewModel?.actionType != .update) {
            btnDelete.isHidden = true
        }else {
            btnDelete.isHidden = false
            btnAddEvent.setTitle("Update", for: .normal)
        }
        if(viewModel?.actionType == .event) {
            btnDelete.setTitle("Delete Event", for: .normal)
        }else if(viewModel?.actionType == .reminder) {
            btnDelete.setTitle("Delete Reminder", for: .normal)
        }
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        txtTitle.delegate = self
        descriptionView.layer.borderWidth = 0.5
        descriptionView.layer.borderColor = UIColor.black.cgColor
       // viewModel = AddEventViewModel()
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
        if(viewModel?.actionType == .update) {
            viewModel?.doAction(action: "update")
        }else if(viewModel?.actionType == .event) {
            viewModel?.doAction(action: "addEvent")
        }else if(viewModel?.actionType == .reminder) {
            viewModel?.doAction(action: "addReminder")
        }
       
        
    }
    
    @IBAction func btnDeleteEvent(_ sender: Any) {
        viewModel?.doAction(action: "deleteEvent")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
extension AddEventViewController: EventAction {
    func updateEvent(eventName: String) {
        switch eventName {
        case "goback":
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
        default:
            break
        }
    }
}
