//
//  DefaultListTableViewCell.swift
//  SeniorProject
//
//  Created by Angie on 4/5/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class DefaultListTableViewCell: UITableViewCell {

    @IBOutlet weak var defaultLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
