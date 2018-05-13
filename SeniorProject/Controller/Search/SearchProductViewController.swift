//
//  SearchProductViewController.swift
//  SeniorProject
//
//  Created by Angie on 4/20/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation


class SearchProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scannerView: UIView!
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var products = [Product]()
    private var filteredProducts = [Product]()
    private var defaultList:[String] = ["Red Wine", "White Wine", "Sparkling Wine", "Rum", "Vodkas", "Champagne", "Tequila"]
    private var searchActive: Bool = false
    private var picksActive: Bool = false
    private var scannerActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        scannerView.isHidden = true
        Helpers.getProducts(completion: { (res) -> () in
            self.products = res
            //            print(self.products.count)
        })
    }
    
    @IBAction func scanProduct(_ sender: UIButton) {
        hideKeyboard()
        prepareCapture()
    }
    
    @IBAction func cancelScan(_ sender: UIButton) {
        captureSession.stopRunning()
        scannerView.isHidden = true
        previewLayer?.removeFromSuperlayer()
        tabBarController?.tabBar.isHidden = false
    }
    
    private func presentOptionFor(index: Int){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "productOption") as? ProductPopUpViewController{
            //TODO: pass data between controllers
            vc.selectedProduct = filteredProducts[index]
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.preferredContentSize = CGSize(width: view.frame.width/2, height: view.frame.height/2)
            tabBarController?.navigationController?.present(vc, animated: false, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive || scannerActive || picksActive) {
            return filteredProducts.count
        }
        else {
            return defaultList.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (searchActive || scannerActive || picksActive){
            return "\(filteredProducts.count) Results Found"
        }
        else {
            return "Top Searches"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (searchActive || picksActive || scannerActive){
            return 150.0
        }
        else {
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(searchActive || scannerActive || picksActive) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "searchedCell", for: indexPath) as? SearchedTableViewCell {
                cell.productName.text = filteredProducts[indexPath.row].name
                cell.productPrice.text = "$ ".appending(filteredProducts[indexPath.row].price.description).appending(" per case")
                cell.productDescription.text = filteredProducts[indexPath.row].description
                let url = filteredProducts[indexPath.row].img.replacingOccurrences(of: " ", with: "%20")
                let path = URLConstants.base.appending(url)
                cell.productImage?.sd_setImage(with: URL(string: path), completed: nil)
                return cell
            }
        }
        else
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as? DefaultPicksTableViewCell {
                if (searchBar.text == ""){
                    hideKeyboard()
                }
                cell.defaultLabel.text = defaultList[indexPath.row]
                filteredProducts.removeAll()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((tableView.cellForRow(at: indexPath) as? SearchedTableViewCell) != nil) {
            print("selected: \(indexPath.row)")
//            presentOptionFor(index: indexPath.row)
        }
        else {
            if(filteredProducts.count == 0){
                searchBar.resignFirstResponder()
                picksActive = true
                searchBar.text = defaultList[indexPath.row]
                searchBar(searchBar, textDidChange: defaultList[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(scannerActive){
            searchBar.text = filteredProducts[indexPath.row].name
            searchBarTextDidEndEditing(searchBar)
        }
    }
}

// MARK: - Search Bar Protocols
extension SearchProductViewController {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if (searchBar.text == ""){
            return
        }
        picksActive = false
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (!(searchBar.text?.isEmpty)!){
            searchActive = true;
        }
        searchBar.resignFirstResponder()
    }
    
    //Function compares search with objects in array
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //if user enters nothing in search bar - return empty data
        if (searchText.isEmpty){
            filteredProducts.removeAll()
            searchActive = false
            picksActive = false
            scannerActive = false
        }
            //Scanner detected
        else if(scannerActive){
            filteredProducts.removeAll()
            filterByID(searchID: searchText)
            if (filteredProducts.count == 0){
                ShowAlert(title: "Whoops", message: "No results found.")
                scannerActive = false
            }
        }
            //Check for Top Picks search
        else if (picksActive) {
            switch(searchText.lowercased()){
            case defaultList[0].lowercased():
                filterByType(searchType: "RW")
                break
            case defaultList[1].lowercased():
                filterByType(searchType: "WW")
                break
            case defaultList[2].lowercased():
                filterByType(searchType: "SW")
                break
            case defaultList[3].lowercased():
                filterByType(searchType: "Rum")
                break
            case defaultList[4].lowercased():
                filterByType(searchType: "VOD")
                break
            case defaultList[5].lowercased():
                filterByType(searchType: "CH")
                break
            case defaultList[6].lowercased():
                filterByType(searchType: "TQ")
                break
            default:
                break
            }
            if (filteredProducts.count == 0){
                picksActive = false
            }
        }
            //Check for search entry
        else {
            filterByName(searchName: searchText)
            searchActive = true
        }
        tableView.reloadData()
    }
}

//MARK: - Search Functions
extension SearchProductViewController {
    func filterByType(searchType: String){
        filteredProducts = products.filter({ (prod) -> Bool in
            let tmp: NSString = prod.type as NSString
            let range = tmp.range(of: searchType, options: NSString.CompareOptions.literal)
            return range.location != NSNotFound
        })
    }
    
    func filterByName(searchName: String){
        let size = searchName.count
        filteredProducts = products.filter({ (prod) -> Bool in
            if prod.name.lowercased().prefix(size) == searchName.lowercased() {
                return true
            }
            return false
        })

        switch (searchName.lowercased().first) {
            case defaultList[0].lowercased().first:
                if defaultList[0].lowercased().contains(searchName.lowercased()){
                    filteredProducts += products.filter({ (prod) -> Bool in
                        let tmp: NSString = prod.type as NSString
                        let range = tmp.range(of: "RW", options: [NSString.CompareOptions.literal])
                        return range.location != NSNotFound
                    })
                }
                else if defaultList[3].lowercased().contains(searchName.lowercased()){
                    filteredProducts += products.filter({ (prod) -> Bool in
                        let tmp: NSString = prod.type as NSString
                        let range = tmp.range(of: "Rum", options: [NSString.CompareOptions.literal])
                        return range.location != NSNotFound
                    })
                }
            case defaultList[1].lowercased().first:
                if defaultList[1].lowercased().contains(searchName.lowercased()){
                    filteredProducts += products.filter({ (prod) -> Bool in
                        let tmp: NSString = prod.type as NSString
                        let range = tmp.range(of: "WW", options: [NSString.CompareOptions.literal])
                        return range.location != NSNotFound
                    })
                }
            case defaultList[2].lowercased().first:
                if defaultList[2].lowercased().contains(searchName.lowercased()){
                    filteredProducts += products.filter({ (prod) -> Bool in
                        let tmp: NSString = prod.type as NSString
                        let range = tmp.range(of: "SW", options: [NSString.CompareOptions.literal])
                        return range.location != NSNotFound
                    })
                }
            case defaultList[4].lowercased().first:
                if defaultList[4].lowercased().contains(searchName.lowercased()){
                    filteredProducts += products.filter({ (prod) -> Bool in
                        let tmp: NSString = prod.type as NSString
                        let range = tmp.range(of: "VOD", options: [NSString.CompareOptions.literal])
                        return range.location != NSNotFound
                    })
                }
            case defaultList[5].lowercased().first:
                if defaultList[5].lowercased().contains(searchName.lowercased()){
                    filteredProducts += products.filter({ (prod) -> Bool in
                        let tmp: NSString = prod.type as NSString
                        let range = tmp.range(of: "CH", options: [NSString.CompareOptions.literal])
                        return range.location != NSNotFound
                    })
                }
            case defaultList[6].lowercased().first:
                if defaultList[6].lowercased().contains(searchName.lowercased()){
                    filteredProducts += products.filter({ (prod) -> Bool in
                        let tmp: NSString = prod.type as NSString
                        let range = tmp.range(of: "TQ", options: [NSString.CompareOptions.literal])
                        return range.location != NSNotFound
                    })
                }
            default:
                break
        }
        tableView.reloadData()
    }
    
    func filterByID(searchID: String){
        filteredProducts = products.filter({ (prod) -> Bool in
            let tmp: NSString = prod.id as NSString
            let range = tmp.range(of: searchID, options: NSString.CompareOptions.literal)
            return range.location != NSNotFound
        })
    }
    
}
//MARK: - Helper Functions
extension SearchProductViewController {
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func ShowAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
            self.searchBar(self.searchBar, textDidChange: "")
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}


//MARK: - Scanner Capture
extension SearchProductViewController: AVCaptureMetadataOutputObjectsDelegate {
    func prepareCapture() {
        tabBarController?.tabBar.isHidden = true
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        view.layer.addSublayer(scannerView.layer)
        scannerView.isHidden = false
        
        captureSession.startRunning()
        
    }
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            scannerActive = true
            searchActive=false
            picksActive = false
            //test barcode - 8902967200115
            searchBar(searchBar, textDidChange: stringValue)
        }
        previewLayer?.removeFromSuperlayer()
        scannerView.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    func found(code: String) {
        print(code)
    }
}


////
////  SearchProductViewController.swift
////  SeniorProject
////
////  Created by Angie on 4/20/18.
////  Copyright © 2018 DrifterDistribution. All rights reserved.
////
//
//import UIKit
////import SDWebImage
//import AVFoundation
//
//class SearchProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var scannerView: UIView!
//
//    private var captureSession: AVCaptureSession!
//    private var previewLayer: AVCaptureVideoPreviewLayer!
//
//    private var products = [Product]()
//    private var filteredProducts = [Product]()
//    private var filteredPicks = [Product]()
//    private var defaultList:[String] = ["Red Wine", "White Wine", "Sparkling Wine", "Rum", "Vodkas", "Champagne", "Tequila"]
//    private var searchActive: Bool = false
//    private var picksActive: Bool = false
//    private var scannerActive: Bool = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        tableView.delegate = self
//        tableView.dataSource = self
//        searchBar.delegate = self
//        scannerView.isHidden = true
//        Helpers.getProducts(completion: { (res) -> () in
//            self.products = res
////            print(self.products.count)
//        })
//    }
//
//    @IBAction func scanProduct(_ sender: UIButton) {
//        hideKeyboard()
//        prepareCapture()
//    }
//
//    @IBAction func cancelScan(_ sender: UIButton) {
//        captureSession.stopRunning()
//        scannerView.isHidden = true
//        previewLayer?.removeFromSuperlayer()
//        tabBarController?.tabBar.isHidden = false
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        if(searchActive || scannerActive) {
//            return filteredProducts.count
//        }
//        else if (picksActive){
//            return filteredPicks.count
//        }
//        else {
//            return defaultList.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if (searchActive || scannerActive){
//            return "\(filteredProducts.count) Results Found"
//        }
//        else if (picksActive){
//            return "\(filteredPicks.count) Results Found"
//        }
//        else {
//            return "Top Searches"
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (searchActive || picksActive || scannerActive){
//            return 150.0
//        }
//        else {
//            return 50.0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if(picksActive) {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "searchedCell", for: indexPath) as? SearchedTableViewCell {
//                cell.productName.text = filteredPicks[indexPath.row].name
//                cell.productPrice.text = "$ ".appending(filteredPicks[indexPath.row].price.description.appending(" per case"))
//                cell.productDescription.text = filteredPicks[indexPath.row].description
//                let url = filteredPicks[indexPath.row].img.replacingOccurrences(of: " ", with: "%20")
//                let path = URLConstants.base.appending(url)
//                cell.productImage?.sd_setImage(with: URL(string: path), completed: nil)
//
//                return cell
//            }
//        }
//        else if(searchActive || scannerActive) {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "searchedCell", for: indexPath) as? SearchedTableViewCell {
//                cell.productName.text = filteredProducts[indexPath.row].name
//                cell.productPrice.text = "$ ".appending(filteredProducts[indexPath.row].price.description).appending(" per case")
//                cell.productDescription.text = filteredProducts[indexPath.row].description
//                let url = filteredProducts[indexPath.row].img.replacingOccurrences(of: " ", with: "%20")
//                let path = URLConstants.base.appending(url)
//                cell.productImage?.sd_setImage(with: URL(string: path), completed: nil)
//                return cell
//            }
//        }
//        else
//        {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as? DefaultPicksTableViewCell {
//                if (searchBar.text == ""){
//                    hideKeyboard()
//                }
//                cell.defaultLabel.text = defaultList[indexPath.row]
//                filteredPicks.removeAll()
//                filteredProducts.removeAll()
//                return cell
//            }
//        }
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //only allow "Top Picks" cells to be selected
//        if(filteredPicks.count == 0 && filteredProducts.count == 0){
//            searchBar.resignFirstResponder()
//            picksActive = true
//            searchBar.text = defaultList[indexPath.row]
//            searchBar(searchBar, textDidChange: defaultList[indexPath.row])
//        }
//
//        print("Selected \(indexPath.row)")
//
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if(scannerActive){
//            searchBar.text = filteredProducts[indexPath.row].name
//            searchBarTextDidEndEditing(searchBar)
//        }
//    }
//}
//
//// MARK: - Search Bar Protocols
//extension SearchProductViewController {
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        if (searchBar.text == ""){
//            return
//        }
//        picksActive = false
//        searchActive = true;
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if (!(searchBar.text?.isEmpty)!){
//            searchActive = true;
//        }
//        searchBar.resignFirstResponder()
//    }
//
//    //Function compares search with objects in array
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //if user enters nothing in search bar - return empty data
//        if (searchText.isEmpty){
//            filteredPicks.removeAll()
//            filteredProducts.removeAll()
//            searchActive = false
//            picksActive = false
//            scannerActive = false
//        }
//            //Scanner detected
//        else if(scannerActive){
//            filteredPicks.removeAll()
//            filteredProducts.removeAll()
//            filterByID(searchID: searchText)
//            if (filteredProducts.count == 0){
//                ShowAlert(title: "Whoops", message: "No results found.")
//                scannerActive = false
//            }
//        }
//            //Check for Top Picks search
//        else if (picksActive) {
//            switch(searchText.lowercased()){
//            case defaultList[0].lowercased():
//                filterByType(searchType: "RW")
//                break
//            case defaultList[1].lowercased():
//                filterByType(searchType: "WW")
//                break
//            case defaultList[2].lowercased():
//                filterByType(searchType: "SW")
//                break
//            case defaultList[3].lowercased():
//                filterByType(searchType: "Rum")
//                break
//            case defaultList[4].lowercased():
//                filterByType(searchType: "VOD")
//                break
//            case defaultList[5].lowercased():
//                filterByType(searchType: "CH")
//                break
//            case defaultList[6].lowercased():
//                filterByType(searchType: "TQ")
//                break
//            default:
//                break
//            }
//            if (filteredPicks.count == 0){
//                picksActive = false
//            }
//        }
//            //Check for search entry
//        else {
//            filterByName(searchName: searchText)
//            searchActive = true
//        }
//
//        //ORIGINAL - SEARCH FOR PRODUCT CODE
//        //IM GOING TO TRY CREATING NEW SEARCH CODE THAT SEARCHES ALL RESULTS RETURNED BY NAME & TYPE
////        if (searchText.isEmpty){
////            filteredPicks.removeAll()
////            filteredProducts.removeAll()
////            searchActive = false
////            picksActive = false
////            scannerActive = false
////        }
////            //Scanner detected
////        else if(scannerActive){
////            filteredPicks.removeAll()
////            filteredProducts.removeAll()
////            filterByID(searchID: searchText)
////            if (filteredProducts.count == 0){
////                ShowAlert(title: "Whoops", message: "No results found.")
////                scannerActive = false
////            }
////        }
////            //Check for Top Picks search
////        else if (picksActive) {
////            switch(searchText.lowercased()){
////            case defaultList[0]:
////                filterByType(searchType: "RW")
////                break
////            case defaultList[1]:
////                filterByType(searchType: "WW")
////                break
////            case defaultList[2]:
////                filterByType(searchType: "SW")
////                break
////            case defaultList[3]:
////                filterByType(searchType: "Rum")
////                break
////            case defaultList[4]:
////                filterByType(searchType: "VOD")
////                break
////            case defaultList[5]:
////                filterByType(searchType: "CH")
////                break
////            case defaultList[6]:
////                filterByType(searchType: "TQ")
////                break
////            case "rum":
////                filterByType(searchType: "Rum")
////                break
////            default:
////                break
////            }
////            if (filteredPicks.count == 0){
////                picksActive = false
////            }
////        }
////            //Check for search entry
////        else {
////            filterByName(searchName: searchText)
////            searchActive = true
////        }
////        //END
//        tableView.reloadData()
//    }
//}
//
////MARK: - Scanner Capture
//extension SearchProductViewController: AVCaptureMetadataOutputObjectsDelegate {
//    func prepareCapture() {
//        tabBarController?.tabBar.isHidden = true
//        captureSession = AVCaptureSession()
//
//        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
//        let videoInput: AVCaptureDeviceInput
//
//        do {
//            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//        } catch {
//            return
//        }
//
//        if (captureSession.canAddInput(videoInput)) {
//            captureSession.addInput(videoInput)
//        } else {
//            failed()
//            return
//        }
//
//        let metadataOutput = AVCaptureMetadataOutput()
//        if (captureSession.canAddOutput(metadataOutput)) {
//            captureSession.addOutput(metadataOutput)
//            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            metadataOutput.metadataObjectTypes = [.ean13]
//        } else {
//            failed()
//            return
//        }
//
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame = view.layer.frame
//        previewLayer.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(previewLayer)
//        view.layer.addSublayer(scannerView.layer)
//        scannerView.isHidden = false
//
//        captureSession.startRunning()
//
//    }
//    func failed() {
//        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
//        captureSession = nil
//    }
//
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        captureSession.stopRunning()
//
//        if let metadataObject = metadataObjects.first {
//            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
//            guard let stringValue = readableObject.stringValue else { return }
//            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            found(code: stringValue)
//            scannerActive = true
//            searchActive=false
//            picksActive = false
//            //test barcode - 8902967200115
//            searchBar(searchBar, textDidChange: stringValue)
//        }
//        previewLayer?.removeFromSuperlayer()
//        scannerView.isHidden = true
//        tabBarController?.tabBar.isHidden = false
//    }
//
//    func found(code: String) {
//        print(code)
//    }
//}
//
////MARK: - Helper Functions
//extension SearchProductViewController {
//    func hideKeyboard() {
//        view.endEditing(true)
//    }
//
//    func filterByType(searchType: String){
//        filteredPicks = products.filter({ (prod) -> Bool in
//            let tmp: NSString = prod.type as NSString
//            let range = tmp.range(of: searchType, options: NSString.CompareOptions.literal)
//            return range.location != NSNotFound
//        })
//
//    }
//
//    func filterByName(searchName: String){
//        filteredProducts = products.filter({ (prod) -> Bool in
//            let tmp: NSString = prod.name as NSString
//            let range = tmp.range(of: searchName, options: [NSString.CompareOptions.caseInsensitive])
//            return range.location != NSNotFound
//        })
//
//        switch (searchName.lowercased().first) {
//            case defaultList[0].lowercased().first:
//                if defaultList[0].lowercased().contains(searchName.lowercased()){
//                    filteredProducts += products.filter({ (prod) -> Bool in
//                        let tmp: NSString = prod.type as NSString
//                        let range = tmp.range(of: "RW", options: [NSString.CompareOptions.literal])
//                        return range.location != NSNotFound
//                    })
//                }
//                else if defaultList[3].lowercased().contains(searchName.lowercased()){
//                    filteredProducts += products.filter({ (prod) -> Bool in
//                        let tmp: NSString = prod.type as NSString
//                        let range = tmp.range(of: "Rum", options: [NSString.CompareOptions.literal])
//                        return range.location != NSNotFound
//                    })
//                }
//            case defaultList[1].lowercased().first:
//                if defaultList[1].lowercased().contains(searchName.lowercased()){
//                    filteredProducts += products.filter({ (prod) -> Bool in
//                        let tmp: NSString = prod.type as NSString
//                        let range = tmp.range(of: "WW", options: [NSString.CompareOptions.literal])
//                        return range.location != NSNotFound
//                    })
//                }
//            case defaultList[2].lowercased().first:
//                if defaultList[2].lowercased().contains(searchName.lowercased()){
//                    filteredProducts += products.filter({ (prod) -> Bool in
//                        let tmp: NSString = prod.type as NSString
//                        let range = tmp.range(of: "SW", options: [NSString.CompareOptions.literal])
//                        return range.location != NSNotFound
//                    })
//                }
//            case defaultList[4].lowercased().first:
//                if defaultList[4].lowercased().contains(searchName.lowercased()){
//                    filteredProducts += products.filter({ (prod) -> Bool in
//                        let tmp: NSString = prod.type as NSString
//                        let range = tmp.range(of: "VOD", options: [NSString.CompareOptions.literal])
//                        return range.location != NSNotFound
//                    })
//                }
//            case defaultList[5].lowercased().first:
//                if defaultList[5].lowercased().contains(searchName.lowercased()){
//                    filteredProducts += products.filter({ (prod) -> Bool in
//                        let tmp: NSString = prod.type as NSString
//                        let range = tmp.range(of: "CH", options: [NSString.CompareOptions.literal])
//                        return range.location != NSNotFound
//                    })
//                }
//            case defaultList[6].lowercased().first:
//                if defaultList[6].lowercased().contains(searchName.lowercased()){
//                    filteredProducts += products.filter({ (prod) -> Bool in
//                        let tmp: NSString = prod.type as NSString
//                        let range = tmp.range(of: "TQ", options: [NSString.CompareOptions.literal])
//                        return range.location != NSNotFound
//                    })
//                }
//            default:
//                break
//        }
//        tableView.reloadData()
//    }
//
//    func filterByID(searchID: String){
//        filteredProducts = products.filter({ (prod) -> Bool in
//            let tmp: NSString = prod.id as NSString
//            let range = tmp.range(of: searchID, options: NSString.CompareOptions.literal)
//            return range.location != NSNotFound
//        })
//    }
//
//    func ShowAlert(title: String, message: String) {
//        // create the alert
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//
//        // add an action (button)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
//            self.searchBar(self.searchBar, textDidChange: "")
//        }))
//        // show the alert
//        self.present(alert, animated: true, completion: nil)
//    }
//}
