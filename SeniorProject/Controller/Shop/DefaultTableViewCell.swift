//
//  DefaultTableViewCell.swift
//  SeniorProject
//
//  Created by Angie on 3/21/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {
    
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
