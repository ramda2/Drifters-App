//
//  SearchViewController.swift
//  SeniorProject
//
//  Created by Angie on 4/5/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var products = [Product]()
    private var filteredProducts = [Product]()
    private var filteredPicks = [Product]()
    private var defaultList:[String] = ["Red Wine", "Rum", "Vodkas", "Champagne", "Tequila"]
    private var picksActive:Bool = false
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        Helpers.getProducts(completion: { (res) -> () in
            self.products = res
            print(self.products.count)
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (picksActive){
            return filteredPicks.count
        }
        else {
            return filteredProducts.count
        }
    }
        

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (picksActive){
            return "\(filteredPicks.count) Results Found"
        }
        return "\(filteredProducts.count) Results Found"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (picksActive){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as? ProductSearchTableViewCell {
                cell.nameLabel.text = filteredPicks[indexPath.row].name
                
                return cell
            }
        }
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as? ProductSearchTableViewCell {
//            cell.nameLabel.text = filteredProducts[indexPath.row].name
//
//            return cell
//        }
        else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath) as? DefaultListTableViewCell {
                cell.defaultLabel.text = defaultList[indexPath.row]
                
                return cell
                }
            }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (filteredPicks.count == 0 &&  filteredProducts.count == 0 ) {
            picksActive = true
        }
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
