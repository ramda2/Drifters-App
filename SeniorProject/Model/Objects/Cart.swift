//
//  Cart.swift
//  SeniorProject
//
//  Created by Angie on 4/20/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import Foundation

class Cart {
    var product:[Product]
    var subtotal:[NSNumber]
    var total:NSNumber
    
    init(product:[Product], subtotal:[NSNumber], total:NSNumber){
        self.product = product
        self.subtotal = subtotal
        self.total = total
    }
}
