//
//  TextReminderCell.swift
//  tecdummy
//
//  Created by eduardo merino padilla on 04/04/18.
//  Copyright © 2018 UX Lab - ISC Admin. All rights reserved.
//

import UIKit

class TextReminderCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var address = ""
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
