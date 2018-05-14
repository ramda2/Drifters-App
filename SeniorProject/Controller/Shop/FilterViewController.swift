//
//  FilterViewController.swift
//  SeniorProject
//
//  Created by Angie on 3/25/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
//    private let headerIdentifier = "headerTitle"
//    private let reuseIdentifier2 = "filterCell"
    
    var products = [Product]()
    var headerTitle:String?
    var filteredProducts = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func presentOptionFor(index: Int){
        DispatchQueue.main.async {
            //            print("inside pop up")
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "productOption") as? ProductPopUpViewController{
                //TODO: pass data between controllers
                vc.selectedProduct = self.filteredProducts[index]
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                vc.preferredContentSize = CGSize(width: self.view.frame.width/2, height: self.view.frame.height/2)
                self.tabBarController?.navigationController?.present(vc, animated: false, completion: nil)
            }
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
extension FilterViewController {
    
    //MARK: - TableView Protocols
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitle ?? ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as? FilterTableViewCell {
            
            let url = filteredProducts[indexPath.row].img.replacingOccurrences(of: " ", with: "%20")
            let path = URLConstants.base.appending(url)
            cell.productImage.sd_setImage(with: URL(string: path), completed: nil)
            cell.productName.text = filteredProducts[indexPath.row].name
//            cell.descLabel.lineBreakMode = .byWordWrapping
//            cell.productDescription.numberOfLines = 2
            cell.productDescription.text = filteredProducts[indexPath.row].description
            cell.productPrice.text = "$ ".appending(filteredProducts[indexPath.row].price.description).appending(" per case")
            
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentOptionFor(index: indexPath.row)
    }
}
