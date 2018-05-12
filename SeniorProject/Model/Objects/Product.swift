//
//  Product.swift
//  SeniorProject
//
//  Created by Angie on 3/20/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import Foundation

class Product {
    var id:String
    var name:String
    var description:String
    var type:String
    var quantity:Int
    var price:String
    var img:String
    
    init(id:String, name:String, description:String, type:String, quantity:Int, price:String, img:String){
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.quantity = quantity
        self.price = price
        self.img = img
    }
}


