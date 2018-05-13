//
//  FilterTableViewCell.swift
//  SeniorProject
//
//  Created by Angie on 5/13/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var productDescription: UILabel!
//    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
