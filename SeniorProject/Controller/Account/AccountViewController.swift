//
//  AccountViewController.swift
//  SeniorProject
//
//  Created by Angie on 4/23/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private let user_settings:[String] = ["View Account Information", "Reset Password", "About Drifters", "Contact Us", "Log out"]
    private let guest_settings:[String] = ["Log In/Register", "About Drifters", "Contact Us"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if KeychainWrapper.standard.bool(forKey: "Guest")!{
            return guest_settings.count
        }
        return user_settings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "accountSetting", for: indexPath) as? AccountTableViewCell {
            
            if KeychainWrapper.standard.bool(forKey: "Guest")!{
                cell.settingLabel.text = guest_settings[indexPath.row]
            }
            else {
                cell.settingLabel.text = user_settings[indexPath.row]
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Tapped - \(settings[indexPath.row])")
        if KeychainWrapper.standard.bool(forKey: "Guest")!{
            switch (indexPath.row){
            case 0:
                //log in/register
                if let vc = storyboard?.instantiateViewController(withIdentifier: "mainVC"){
                    tabBarController?.navigationController?.present(vc, animated: false, completion: nil)
                }
                break
            case 1:
                //about us
                if let vc = storyboard?.instantiateViewController(withIdentifier: "aboutVC") {
                    navigationController?.pushViewController(vc, animated: true)
                }
                break
            case 2:
                //contact us
                if let vc = storyboard?.instantiateViewController(withIdentifier: "contactVC") as? ContactViewController{
                    navigationController?.pushViewController(vc, animated: true)
                }
                break
            default:
                break
            }
        }
        else {
            switch (indexPath.row){
            case 0:
                if let vc = storyboard?.instantiateViewController(withIdentifier: "showDetail") as? DisplayDetailViewController{
                    navigationController?.pushViewController(vc, animated: true)
                }
                break
            case 1:
                //reset password
                if let vc = storyboard?.instantiateViewController(withIdentifier: "resetVC") as? PasswordPopUpViewController {
                    vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    vc.preferredContentSize = CGSize(width: view.frame.width/2, height: view.frame.height/2)
                    tabBarController?.navigationController?.present(vc, animated: false, completion: nil)
                }
                break
            case 2:
                //about us
                if let vc = storyboard?.instantiateViewController(withIdentifier: "aboutVC") {
                    navigationController?.pushViewController(vc, animated: true)
                }
                break
            case 3:
                //contact us
                if let vc = storyboard?.instantiateViewController(withIdentifier: "contactVC") as? ContactViewController{
                    navigationController?.pushViewController(vc, animated: true)
                }
                break
            case 4:
                //logout
                ShowAlert(title: "Logout", message: "Are you sure you want to logout?")
                break
            default:
                break
            }
        }
    }

    private func ShowAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
            Helpers.logout()
            self.presentViewController(identifier: "mainVC")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
            self.tableView.reloadData()
        }))
        // show the alert
        self.present(alert, animated: false, completion: nil)
    }
    
    private func presentViewController(identifier: String){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        tabBarController?.navigationController?.present(viewController, animated: false, completion: nil)
//        self.present(viewController, animated: true, completion: nil)
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
