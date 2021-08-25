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
        guard let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") else { return  }
        self.navigationController?.pushViewController(obj, animated: true)
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
