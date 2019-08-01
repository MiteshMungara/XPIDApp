//
//  GlobalHistoryCell.swift
//  XPIDApp
//
//  Created by Mits on 9/29/18.
//  Copyright © 2018 MitTech. All rights reserved.
//

import UIKit

class GlobalHistoryCell: UITableViewCell {

    
    @IBOutlet var rankingLabel:UILabel!
    @IBOutlet var earnPointLabel:UILabel!
    
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var addressLabel:UILabel!
    @IBOutlet var cityLabel:UILabel!
    @IBOutlet var stateLabel:UILabel!
    @IBOutlet var satisfyXPLabel:UILabel!
    @IBOutlet var friendandfamilyXPLabel:UILabel!
    @IBOutlet var descriptionLabel:UILabel!
    @IBOutlet var currentdateLabel:UILabel!
    @IBOutlet var placeImage:UIImageView!
    
    @IBOutlet var satisfyXPTitleLabel:UILabel!
    @IBOutlet var friendandfamilyXPTitleLabel:UILabel!
    
//    @IBOutlet var name:UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
