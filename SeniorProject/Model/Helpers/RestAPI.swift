//
//  RestAPI.swift
//  SeniorProject
//
//  Created by Angie on 3/19/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
   
    func PostHTTPRequest(path: String, args: String, onCompletion: @escaping ServiceResponse) {
        
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        request.httpMethod = "POST"
        request.httpBody = args.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
//            print(response)
//            print(data)
            if let data = data {
                let json:JSON = JSON(data: data)
                DispatchQueue.main.async(execute: { onCompletion(json,error as NSError?) } )
            }
//            print(response)
        })
        task.resume()
    }
    
    func buildLoginPostString(model:User) -> String {
        let postString = "username=\(model.username)&password=\(model.password)"
        return postString
    }
    
    func buildRegistrationPostString(model: UserDetails) -> String {
        print(model.username)
        print(model.password)
        let postString = "Name=\(model.name)&License_Num=\(model.license)&Address=\(model.address)&City=\(model.city)&State=\(model.state)&Zip=\(model.zip)&Email=\(model.email)&Phone=\(model.phone)&Username=\(model.username)&Password=\(model.password)"
        print(postString)
        return postString
    }

}
