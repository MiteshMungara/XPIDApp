//
//  LocationNearestCell.swift
//  XPIDApp
//
//  Created by Mits on 9/23/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit

class LocationNearestCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var placeImage: UIImageView!
    @IBOutlet var postxpButton: UIButton!
//    @IBOutlet var LocationLabel: UILabel!
//    @IBOutlet var LocationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
