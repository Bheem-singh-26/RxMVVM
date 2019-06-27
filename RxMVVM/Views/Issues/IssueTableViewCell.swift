//
//  IssueTableViewCell.swift
//  RxMVVM
//
//  Created by Bheem Singh on 27/06/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var cellIssue : Issue! {
        didSet {
            self.titleLabel.text = self.cellIssue.title
            self.descriptionLabel.text = self.cellIssue.description.maxLength(length: 140)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
