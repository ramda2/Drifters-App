//
//  DisplayDetailViewController.swift
//  SeniorProject
//
//  Created by Angie on 5/14/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class DisplayDetailViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var license: UITextField!
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Helpers.getUserInfo(completion: { (userDetails) in
            self.name.text = userDetails.name
            self.license.text = userDetails.license
            self.address.text = userDetails.address
            self.city.text = userDetails.city
            self.state.text = userDetails.state
            self.zip.text = userDetails.zip
            self.email.text = userDetails.email
            self.phone.text = userDetails.phone
            self.username.text = userDetails.username
        })
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
