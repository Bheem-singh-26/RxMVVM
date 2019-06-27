//
//  CommnetTableViewCell.swift
//  RxMVVM
//
//  Created by Bheem Singh on 27/06/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import UIKit

class CommnetTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var cellComment : Comment! {
        didSet {
            self.userImage.image = #imageLiteral(resourceName: "defaultUserIcon")
            let imageUrl = self.cellComment.user.avatar_url
            self.userImage.loadImage(fromURL: imageUrl)
            self.nameLabel.text = self.cellComment.user.name
            self.descriptionLabel.text = self.cellComment.description
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
