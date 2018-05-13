//
//  StartViewController.swift
//  SeniorProject
//
//  Created by Angie on 3/1/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var userAcctButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = 10.0
        userAcctButton.layer.cornerRadius = 10.0
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
        if segue.identifier == "guestSegue" {
//            KeychainWrapper.standard.removeAllKeys()
            KeychainWrapper.standard.set(true, forKey: "Guest")
            print("Guest mode")
        }
        if segue.identifier == "checkSegue" {
            KeychainWrapper.standard.set(false, forKey: "Guest")
            print("User mode")
        }
    }

}
