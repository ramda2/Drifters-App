//
//  SearchTableViewController.swift
//  SeniorProject
//
//  Created by Angie on 3/21/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    var filteredProducts = [Product]()
    var products = [Product]()
    var defaultList:[String] = ["Red Wine", "Rum", "Vodkas", "Champagne", "Tequila"]
    var searchActive : Bool = false
    var resultLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
        
        tableView.tableHeaderView? = searchBar
//        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        resultLabel.textAlignment = .center
        tableView.backgroundView = resultLabel
        view.addSubview(resultLabel)
        resultLabel.isHidden = true
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        getProducts(completion: { (res) -> () in
            if (res){
                print(self.products.count)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProducts(completion: @escaping (Bool) ->()){
        let path = URLConstants.base.appending(URLConstants.methodCall)
        let postString = "getProducts=Product"
        
        RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
            (json, err) in
            print(json)
            //            let total:Int = Int(json["count"].stringValue)!
            
            if let items = json["items"].array {
                for item in items {
                    let line = item.arrayObject as! [String]
                    //                    print(line)
                    let id:Int = Int(line[0])!
                    let name:String = line[1]
                    let description:String = line[2]
                    let type:String = line[3]
                    let quantity:Int = Int(line[4])!
                    let price:Double = Double(line[5])!
                    let img:String = line[6]
                    self.products.append(Product(id: id, name: name, description: description, type: type, quantity: quantity, price: price, img: img))
                }
            }
            if(self.products.count > 0){
                completion(true)
            }
        }
    }
    
    // MARK: - Search Bar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.text = ""
//        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        resultLabel.isHidden = true
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            filteredProducts = products.filter({ (prod) -> Bool in
                let tmp: NSString = prod.name as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
        }
        if(filteredProducts.count == 0){
            resultLabel.text = "No results found"
            resultLabel.isHidden = false
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive) {
            return filteredProducts.count
        }
        else {
            return defaultList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (searchActive){
            return "\(filteredProducts.count) Results Found"
        }
        else {
            return "Top Searches"
        }
    }
    
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (searchActive){
            return 150.0
        }
        else {
            return 50.0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        if(searchActive){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as? SearchTableViewCell {
            
                cell.titleLabel.text = filteredProducts[indexPath.row].name
                cell.priceLabel.text = "$ ".appending(filteredProducts[indexPath.row].price.description)
                cell.descriptionLabel.text = filteredProducts[indexPath.row].description
                
                let path = URLConstants.base.appending(filteredProducts[indexPath.row].img)
                cell.iconImage?.sd_setImage(with: URL(string: path), completed: nil)
                return cell
            }
        }
        else {
            resultLabel.isHidden = true
            if let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath) as? DefaultTableViewCell {
                cell.titleLabel.text = defaultList[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }

//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if (searchActive && filteredProducts.count == 0 && products.count > 0){
//            return "No results found"
//        }
//        return nil
//    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
