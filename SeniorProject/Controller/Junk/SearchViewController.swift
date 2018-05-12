//
//  HomeViewController.swift
//  SeniorProject
//
//  Created by Angie on 3/15/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var results = [Product]()
    
    //for images use this url
    //http://teamdrifters.online/image//BollaPresseco.jpg
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        imageView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchItem(search: String){
        let path = URLConstants.base.appending(URLConstants.methodCall)
        let postString = "search=\(search)"
        
        RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
            (json, err) in
    //            print(json)
            
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
                    self.results.append(Product(id: id, name: name, description: description, type: type, quantity: quantity, price: price, img: img))
                }
                self.tableView.reloadData()
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
    

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //fix images from being downloaded
        let cell = tableView.dequeueReusableCell(withIdentifier: "displayCell", for: indexPath) as? SearchTableViewCell
        cell?.titleLabel.text = results[indexPath.row].name
//        cell?.descriptionLabel.text = results[indexPath.row].description
//        cell?.priceLabel.text = results[indexPath.row].price.description
        let path = URLConstants.base.appending(results[indexPath.row].img)
        cell?.iconImage?.contentMode = .scaleAspectFit
        cell?.iconImage?.sd_setImage(with: URL(string: path), completed: nil)
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

extension SearchViewController: AVCaptureMetadataOutputObjectsDelegate {
    
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
            imageView.isHidden = true
        }
        dismiss(animated: true)
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
    
    @IBAction func BarcodeScanner(_ sender: UIButton) {
        searchItem(search: "Bolla")
        
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
        //        self.view.layer.addSublayer(self.previewLayer)
        //        self.view.layer.addSublayer(self.imageView.layer)
        //        self.imageView.isHidden = false
        //
        //        captureSession.startRunning()
    }
}
