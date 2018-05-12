//
//  Customer.swift
//  SeniorProject
//
//  Created by Angie on 3/1/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import Foundation

public class User {
    var username:String
    var password:String
    
    static var storeID = String()
    
    init(username:String, password:String){
        self.username = username
        self.password = password
    }
}

public class UserDetails: User {
    var name: String
    var license:String
    var address:String
    var city: String
    var state:String
    var zip:String
    var email:String
    var phone:String
  
    init(name:String, license:String, address:String, city:String, state:String, zip:String, email:String, phone:String, username:String, password:String){
        self.name = name
        self.license = license
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        self.email = email
        self.phone = phone
        super.init(username: username, password: password)
    }
}

