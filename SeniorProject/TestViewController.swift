//
//  TestViewController.swift
//  SeniorProject
//
//  Created by Angie on 3/8/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func Login(_ sender: UIButton) {
        let postString = "username=\(user.text!)&password=\(pass.text!)"
        let request = NSMutableURLRequest(url: NSURL(string: "http://teamdrifters.online/check_pass.php")! as URL)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse
            {
                print("httpResponse status code \(httpResponse.statusCode)")
                if let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    print(responseString)
                }
            }
        }
        task.resume()
    
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
