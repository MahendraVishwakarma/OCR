//
//  EventsViewController.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 25/08/21.
//

import UIKit

class EventsViewController: BaseViewController {
    @IBOutlet weak var eventListTableView: UITableView!
    var viewModel: EventViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    private func setup(){
        eventListTableView.register(UINib(nibName: "EventListTableViewCell", bundle: nil), forCellReuseIdentifier: "eventList")
        viewModel = EventViewModel()
        eventListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.totalEvents =  viewModel?.getEvents()
        eventListTableView.reloadData()
    }
    
    @IBAction func addEvent() {
        let alert = UIAlertController(title: "Choose Action type", message: "please select one", preferredStyle: .actionSheet)
        let event = UIAlertAction(title: "Event", style: .default) { (alt) in
            alert.dismiss(animated: true, completion: nil)
            
            guard let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") as? AddEventViewController  else { return  }
            obj.viewModel = AddEventViewModel()
            obj.viewModel?.actionType = .event
            self.navigationController?.pushViewController(obj, animated: true)
        }
        let reminder = UIAlertAction(title: "Reminder", style: .default) { (alt) in
            alert.dismiss(animated: true, completion: nil)
            
            guard let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") as? AddEventViewController else { return  }
            obj.viewModel = AddEventViewModel()
            obj.viewModel?.actionType = .reminder
            self.navigationController?.pushViewController(obj, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(event)
        alert.addAction(reminder)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }

}
extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.totalEvents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventList") as? EventListTableViewCell else {
           return UITableViewCell()
        }
        if let eve = viewModel?.totalEvents?[indexPath.row] {
            cell.configure(event: eve)
        }
       
        return cell
    }
    
    
}
