//
//  ShopViewController.swift
//  SeniorProject
//
//  Created by Angie on 3/25/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var titles = ["Wine", "Liquor"]
    private var subTitles = ["Wine": ["Red Wine", "White Wine", "Sparkling Wine", "Champagne"], "Liquor": ["Rum", "Vodkas", "Tequila"]]
    
    private var products = [Product]()
    private var filteredProducts = [Product]()
    private var selectedTitle: String?
    //identifiers
    private let reuseIdentifier = "browseCell"
    private let headerIdentifier = "headerTitle"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        //retrieve all products on load
        Helpers.getProducts(completion: { (res) -> () in
            self.products = res
//            print(self.products.count)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    func filterByType(searchType: String){
        filteredProducts = products.filter({ (prod) -> Bool in
            let tmp: NSString = prod.type as NSString
            let range = tmp.range(of: searchType, options: NSString.CompareOptions.literal)
            return range.location != NSNotFound
        })
    }
    
    func filterCells(filterBy: String){
        switch(filterBy){
        case "Red Wine":
            filterByType(searchType: "RW")
            break
        case "White Wine":
            filterByType(searchType: "WW")
            break
        case "Sparkling Wine":
            filterByType(searchType: "SW")
            break
        case "Champagne":
            filterByType(searchType: "CH")
            break
        case "Rum":
            filterByType(searchType: "Rum")
        case "Vodkas":
            filterByType(searchType: "VOD")
            break
        case "Tequila":
            filterByType(searchType: "TQ")
            break
        default:
            break
        }
//        print(filteredProducts.count)
        if (filteredProducts.count > 0){
            //pass data tp instantiated vc
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let vc = storyboard.instantiateViewController(withIdentifier: "showItems") as? FilterViewController{
                //TODO: pass data between controllers
                vc.filteredProducts = filteredProducts
                vc.headerTitle = filterBy
                filteredProducts.removeAll()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension ShopViewController {
    
    //MARK: - CollectionView Protocols
    func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        for (key,val) in subTitles{
            if(titles[section] == key){
                return val.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                            withReuseIdentifier: headerIdentifier,
                                                                            for: indexPath) as? ShopHeaderCollectionReusableView {

            headerView.headerLabel.text = titles[indexPath.section]
            return headerView
        }
        else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ShopCollectionViewCell {
            
            for (key,val) in subTitles{
                if(titles[indexPath.section] == key){
                    cell.typeLabel.text = val[indexPath.row]
                    cell.productImage.image = UIImage.init(named: val[indexPath.row])
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for (key,val) in subTitles{
            if(titles[indexPath.section] == key){
//                print("Tapped - \(val[indexPath.row])")
                filterCells(filterBy: val[indexPath.row])
            }
        }
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  20
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
}


