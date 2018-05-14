//
//  Helpers.swift
//  SeniorProject
//
//  Created by Angie on 3/25/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import Foundation

struct Helpers {
//    static var session_id = String()
    
    static func getUserInfo(completion: @escaping (UserDetails) -> ()){
        if let session: String = KeychainWrapper.standard.string(forKey: "Session"){
            if let username = KeychainWrapper.standard.string(forKey: "Username"){
                if let password = KeychainWrapper.standard.string(forKey: "Password"){
                    let path = URLConstants.base.appending(URLConstants.user_details)
                    
                    let postString = "Session=\(session)"
                    RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
                        (json, err) in
                        //            print(json)
                        
                        if let details = json["data"].array {
                            for item in details {
                                let line = item.arrayObject as! [String]
                                //                    print(line)
                                let name:String = line[1]
                                let license:String = line[2]
                                let address:String = line[3]
                                let city:String = line[4]
                                let state:String = line[5]
                                let zip:String = line[6]
                                let email:String = line[7]
                                let phone:String = line[8]
                                
                                let user = UserDetails(name: name, license: license, address: address, city: city, state: state, zip: zip, email: email, phone: phone, username: username, password: password)
                                    
                                completion(user)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //returns list of all products
    static func getProducts(completion: @escaping ([Product]) ->()){
        let path = URLConstants.base.appending(URLConstants.methodCall)
        let postString = "getProducts=Product"
        var products = [Product]()
        RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
            (json, err) in
//            print(json)
            //            let total:Int = Int(json["count"].stringValue)!

            if let items = json["items"].array {
                for item in items {
                    if let line = item.arrayObject as? [String] {
                    //                    print(line)
                        let id:String = line[0]
                        let name:String = line[1]
                        let description:String = line[2]
                        let type:String = line[3]
                        let quantity:Int = Int(line[4])!
                        let price:String = line[5]
                        let img:String = line[6]

                        products.append(Product(id: id, name: name, description: description, type: type, quantity: quantity, price: price, img: img))
                    }
                }
            }
            let count:Int = json["count"].intValue
            print("\(count) products loaded.")
            if(products.count > 0){
                completion(products)
            }
        }
    }

    static func getProductsFromCart(completion: @escaping (Cart) ->()){
        let path = URLConstants.base.appending(URLConstants.getCart)
        if let session = KeychainWrapper.standard.string(forKey: "Session"){
            let postString = "Session=\(session)"
            var products = [Product]()
            var subtotal = [NSNumber]()
            var model:Cart?
            RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
                (json, err) in
    //            print(json)
                let count:Int = json["count"].intValue
                print("\(count) product(s) in cart.")
                let total:NSNumber = json["total"].numberValue
                if (count > 0) {
                    if let items = json["items"].array {
                        for item in items {
                            if let line = item.dictionary {
                                subtotal.append((line["subtotal"]?.numberValue)!)
    //                            print(subtotal)
                            }
                            if let line = item.arrayObject as? [String]{
    //                            print(line)
                                let id:String = line[0]
                                let name:String = line[1]
                                let description:String = line[2]
                                let type:String = line[3]
                                let price:String = line[4]
                                let quantity:Int = Int(line[5])!
                                let img:String = line[6]
                                products.append(Product(id: id, name: name, description: description, type: type, quantity: quantity, price: price, img: img))
                            }
                        }
                    }
                }
                model = Cart(product: products, subtotal: subtotal, total: total)
//                print(total)
                if let cart = model {
                    completion(cart)
                }
            }
        }
    }
    
    static func addItem_Cart(model: Product, completion: @escaping (Bool, String?) -> ()){
        let path = URLConstants.base.appending(URLConstants.addItem)
        if let session: String = KeychainWrapper.standard.string(forKey: "Session"){
            let postString = "Session=\(session)&Product_ID=\(model.id)&Quantity=\(model.quantity)"
            RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
                (json, err) in
//                print(json)
                if let alert = json["alert"].string{
                        //                    print(alert)
                    completion(false, alert)
                }
                else {
                    completion(true, nil)
                }
                
                if let response = json["response"].string {
                    print(response)
                }
            }
        }
    }
    
    static func removeItem_Cart
        (model: Product, completion: @escaping ((Bool) -> ())) {
        let path = URLConstants.base.appending(URLConstants.removeItem)
        if let session: String = KeychainWrapper.standard.string(forKey: "Session"){
            let postString = "Product_ID=\(model.id)&Session=\(session)"
            RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
                (json, err) in
    //            print(json)
    //            print(status)
                if let response:String = json["response"].string {
                    print(response)
                }
                let status:Bool = json["status"].boolValue
                completion(status)
            }
        }
    }
    
    static func checkQuantity(model: Product, completion: @escaping (Bool, String?) -> ()){
        let path = URLConstants.base.appending(URLConstants.checkQty)
        let postString = "Product_ID=\(model.id)&Quantity=\(model.quantity)"
        RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
            (json, err) in
            //            print(json)
            if let response:String = json["response"].string {
                print(response)
            }
            let status:Bool = json["limited"].boolValue
            if let message:String = json["response"].string {
                completion(status, message)
            }
            else {
                completion(status, nil)
            }
        }
    }

    static func placeOrder(completion: @escaping (Bool, Bool) -> ()){
        if let session: String = KeychainWrapper.standard.string(forKey: "Session"){
            let path = URLConstants.base.appending(URLConstants.placeOrder)
        
            let postString = "Session=\(session)"
            RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
                (json, err) in
                //            print(json)
                if let order_status:Bool = json["order_completed"].bool{
                    if let update_status:Bool = json["update_completed"].bool {
                        completion(order_status, update_status)
                    }
                }
            }
        }
    }
    
    static func contact(name: String, email:String, phone:String?, comment:String, completion: @escaping (Bool) -> ()){
        let path = URLConstants.base.appending(URLConstants.contact)
        
        let postString = "Name=\(name)&Email=\(email)&Phone=\(phone ?? "")&Comment=\(comment)"
        RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
            (json, err) in
            //            print(json)
            if let status:Bool = json["complete"].bool{
                completion(status)
            }
        }
    }
    
    static func EmailInvoice(user: UserDetails, model: Cart, completion: @escaping (Bool) -> ()){
        if let session: String = KeychainWrapper.standard.string(forKey: "Session"){
            let path = URLConstants.base.appending(URLConstants.emailInvoice)
            
            let postString = "Session=\(session)&Total=\(model.total)&Email=\(user.email)"
            RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
                (json, err) in
//                            print(json)
                print(json["completed"])
                if let status:Bool = json["completed"].bool {
                    completion(status)
                }
            }
        }
    }
    
    static func logout(){
        let path = URLConstants.base.appending(URLConstants.methodCall)
        RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: "") {
            (json, err) in
            if let response:String = json["response"].string {
                print(response)
            }
        }
    }
}

