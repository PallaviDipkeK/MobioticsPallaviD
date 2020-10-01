//
//  DetailVideoCell.swift
//  MobioticsPallaviD
//
//  Created by Administrator on 03/04/20.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class DetailVideoCell: UITableViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
