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
        if segue.identifier == "bypassSegue" {
//            KeychainWrapper.standard.removeAllKeys()
        }
    }

}
