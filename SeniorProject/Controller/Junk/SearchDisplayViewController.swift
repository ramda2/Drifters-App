//
//  SearchDisplayViewController.swift
//  SeniorProject
//
//  Created by Angie on 3/20/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit
import SDWebImage

class SearchDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    var filteredProducts = [Product]()
    var products = [Product]()
    var searchActive : Bool = false
    var topPicks:[String] = ["Red Wine", "Rum", "Vodkas", "Champagne", "Tequila"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
        activityIndicator.isHidden = true
        getProducts(completion: { (res) -> () in
            if (res){
                print(self.products.count)
            }
        }
        )
        self.tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "displayCell")
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ScanUPC(_ sender: UIButton) {
//        searchItem(search: "Bolla")
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredProducts = products.filter({ (prod) -> Bool in
            let tmp: NSString = prod.name as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filteredProducts.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
//        self.tableView.reloadData()
    }

    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        shouldShowSearchResults = true
//
//        if let text = searchBar.text {
//            searchItem(search: text) {
//                (status) -> () in
//                // do stuff with the result
//                if (status && self.filteredProducts.count > 0){
//                    print(self.filteredProducts.count)
//                    self.activityIndicator.stopAnimating()
////                    self.tableView.reloadData()
//                }
//                else {
//                    self.activityIndicator.startAnimating()
//
//                }
//            }
//        }
//        searchBar.resignFirstResponder()
//    }
    
    func alterLayout(){
        tableView.tableHeaderView = UIView()
    }
    
//    func searchItem(search: String, completion: @escaping (Bool) ->()) {
//        let path = URLConstants.base.appending(URLConstants.methodCall)
//        let postString = "search=\(search)"
//        var buildArr = [Product]()
//
//        RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
//            (json, err) in
//            //            print(json)
//            if let items = json["items"].array {
//                for item in items {
//                    let line = item.arrayObject as! [String]
//                    //                    print(line)
//                    let id:Int = Int(line[0])!
//                    let name:String = line[1]
//                    let description:String = line[2]
//                    let type:String = line[3]
//                    let quantity:Int = Int(line[4])!
//                    let price:Double = Double(line[5])!
//                    let img:String = line[6]
//                    buildArr.append(Product(id: id, name: name, description: description, type: type, quantity: quantity, price: price, img: img))
//                }
////                DispatchQueue.main.async {
////                }
//            }
//            self.filteredProducts = buildArr
//            self.tableView.reloadData()
//        }
//        completion(true)
//    }
    
        //MARK: - Tableview Delegate & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredProducts.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //fix images from being downloaded
        
//        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchTableViewCell
//        else {  return UITableViewCell() }
        if(searchActive){
            cell.titleLabel.text = filteredProducts[indexPath.row].name
//            cell.priceLabel.text = filteredProducts[indexPath.row].price.description
//            cell.descriptionLabel.text = filteredProducts[indexPath.row].description

            let path = URLConstants.base.appending(filteredProducts[indexPath.row].img)
            cell.iconImage?.sd_setImage(with: URL(string: path), completed: nil)
        }
        
        return cell
//        if (shouldShowSearchResults && filteredProducts.count > 0) {
//            cell.titleLabel.text = filteredProducts[indexPath.row].name
//            cell.priceLabel.text = filteredProducts[indexPath.row].price.description
//            cell.descriptionLabel.text = filteredProducts[indexPath.row].description
//
//            let path = URLConstants.base.appending(filteredProducts[indexPath.row].img)
//            cell.iconImage?.sd_setImage(with: URL(string: path), completed: nil)
//        }
//        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
