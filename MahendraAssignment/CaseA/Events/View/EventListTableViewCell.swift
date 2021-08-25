//
//  EventListTableViewCell.swift
//  MahendraAssignment
//
//  Created by Mahendra Vishwakarma on 25/08/21.
//

import UIKit

class EventListTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var evenetDescr: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(event:Events?) {
        let titleValue = event?.value(forKeyPath: "title") as? String
        let dateValue = event?.value(forKeyPath: "date") as? String
        let det = event?.value(forKeyPath: "event_description") as? String
        title?.text = titleValue
       
        date?.text = dateValue
        evenetDescr?.text = det
    }
    
}
