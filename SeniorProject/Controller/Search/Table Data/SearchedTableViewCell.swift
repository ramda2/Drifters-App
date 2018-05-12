//
//  SearchedTableViewCell.swift
//  SeniorProject
//
//  Created by Angie on 4/20/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class SearchedTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
