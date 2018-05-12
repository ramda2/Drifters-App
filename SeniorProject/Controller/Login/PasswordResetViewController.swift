//
//  PasswordResetViewController.swift
//  SeniorProject
//
//  Created by Angie on 3/7/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class PasswordResetViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ResetPassword(_ sender: UIButton) {
        if (emailTextField.text == ""){
            return
        }
        let postString = "ForgotPassword&email_address=\(emailTextField.text!)"
        let path = URLConstants.base.appending(URLConstants.reset)
        RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
            (json, err) in
            print(json)
            self.ShowAlert(title: "Reset", message: json["message"].stringValue)
            
        }
        
    }
    private func ShowAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
            self.emailTextField.text = ""
//            if (self.authorized){
//                                self.performSegue(withIdentifier: "Tutorial", sender: self)
//            }
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
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


