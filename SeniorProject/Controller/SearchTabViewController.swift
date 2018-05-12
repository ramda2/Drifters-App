//
//  SearchTabViewController.swift
//  SeniorProject
//
//  Created by Angie on 3/21/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

class SearchTabViewController: UIViewController {
    
//    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var scannerView: UIView!
//    @IBOutlet weak var cancelScan: UIButton!
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var products = [Product]()
    private var filteredProducts = [Product]()
    private var filteredPicks = [Product]()
    private var defaultList:[String] = ["Red Wine", "Rum", "Vodkas", "Champagne", "Tequila"]
    private var searchActive: Bool = false
    private var picksActive: Bool = false
    private var scannerActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
//        scannerView.isHidden = true
//        cancelScan.layer.cornerRadius = 10.0
        //retrieve all products on load
        Helpers.getProducts(completion: { (res) -> () in
            self.products = res
            print(self.products.count)
        })
    }
    
    @IBAction func BarcodeScanner(_ sender: UIButton) {
        hideKeyboard()
        prepareCapture()
    }
    
    @IBAction func cancelScan(_ sender: UIButton) {
        captureSession.stopRunning()
//        scannerView.isHidden = true
        previewLayer?.removeFromSuperlayer()
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Search Bar Protocols
extension SearchTabViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        if (searchBar.text == ""){
            searchActive = false
        }
        else {
            searchActive = true;
        }
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
            filteredPicks.removeAll()
            filteredProducts.removeAll()
            searchActive = false
            picksActive = false
            scannerActive = false
        }
        //Scanner detected
        else if(scannerActive){
            filteredPicks.removeAll()
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
                case "red wine":
                    filterByType(searchType: "RW")
                    break
                case "rum":
                    filterByType(searchType: "Rum")
                    break
                case "vodkas":
                    filterByType(searchType: "VOD")
                    break
                case "champagne":
                    filterByType(searchType: "CH")
                    break
                case "tequila":
                    filterByType(searchType: "TQ")
                    break
            default:
                break
            }
            if (filteredPicks.count == 0){
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

// MARK: - TableView Protocols
extension SearchTabViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive || scannerActive) {
            return filteredProducts.count
        }
        else if (picksActive){
            return filteredPicks.count
        }
        else {
            return defaultList.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (searchActive || scannerActive){
            return "\(filteredProducts.count) Results Found"
        }
        else if (picksActive){
            return "\(filteredPicks.count) Results Found"
        }
        else {
            return "Top Searches"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (searchActive || picksActive || scannerActive){ //} || scannerActive){
            return 150.0
        }
        else {
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        if(picksActive) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell {
                cell.titleLabel.text = filteredPicks[indexPath.row].name
                cell.priceLabel.text = "$ ".appending(filteredPicks[indexPath.row].price.description.appending(" per case"))
                
                let url = filteredPicks[indexPath.row].img.replacingOccurrences(of: " ", with: "%20")
                let path = URLConstants.base.appending(url)
                cell.iconImage?.sd_setImage(with: URL(string: path), completed: nil)
                
                return cell
            }
        }
        else if(searchActive || scannerActive) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell {
                cell.titleLabel.text = filteredProducts[indexPath.row].name
                cell.priceLabel.text = "$ ".appending(filteredProducts[indexPath.row].price.description).appending(" per case")
//                cell.descriptionLabel.text = filteredProducts[indexPath.row].description
                let url = filteredProducts[indexPath.row].img.replacingOccurrences(of: " ", with: "%20")
                let path = URLConstants.base.appending(url)
                cell.iconImage?.sd_setImage(with: URL(string: path), completed: nil)
                return cell
            }
        }
        else
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as? DefaultTableViewCell {
                if (searchBar.text == ""){
                    hideKeyboard()
                }
                cell.titleLabel.text = defaultList[indexPath.row]
                filteredPicks.removeAll()
                filteredProducts.removeAll()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //only allow "Top Picks" cells to be selected
        if(filteredPicks.count == 0 && filteredProducts.count == 0){
            searchBar.resignFirstResponder()
            picksActive = true
            searchBar.text = defaultList[indexPath.row]
            searchBar(searchBar, textDidChange: defaultList[indexPath.row])
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(scannerActive){
            searchBar.text = filteredProducts[indexPath.row].name
            searchBarTextDidEndEditing(searchBar)
        }
    }
}

//MARK: - Camera Output
extension SearchTabViewController: AVCaptureMetadataOutputObjectsDelegate {
    
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
//        view.layer.addSublayer(scannerView.layer)
//        scannerView.isHidden = false
        
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
//        scannerView.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    func found(code: String) {
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}

//MARK: - Helper Functions
extension SearchTabViewController {
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func filterByType(searchType: String){
        filteredPicks = products.filter({ (prod) -> Bool in
            let tmp: NSString = prod.type as NSString
            let range = tmp.range(of: searchType, options: NSString.CompareOptions.literal)
            return range.location != NSNotFound
        })
        
    }
    
    func filterByName(searchName: String){
        filteredProducts = products.filter({ (prod) -> Bool in
            let tmp: NSString = prod.name as NSString
            let range = tmp.range(of: searchName, options: [NSString.CompareOptions.literal])
            return range.location != NSNotFound

        })
        
    }
    
    func filterByID(searchID: String){
        filteredProducts = products.filter({ (prod) -> Bool in
            let tmp: NSString = prod.id as NSString
            let range = tmp.range(of: searchID, options: NSString.CompareOptions.literal)
            return range.location != NSNotFound
        })
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


