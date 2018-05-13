//
//  SegmentedViewController.swift
//  SeniorProject
//
//  Created by Angie on 3/21/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class SegmentedViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var segmentedControl: CustomSegmentControl!
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }
    
    private var currentViewController: UIViewController?
    private lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
        return firstChildTabVC
    }()
    private lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "detail1VC")
        
        return secondChildTabVC
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        segmentedControl.initUI()
        segmentedControl.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    private func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
            case TabIndex.firstChildTab.rawValue :
                vc = firstChildTabVC
            case TabIndex.secondChildTab.rawValue :
                vc = secondChildTabVC
            default:
                return nil
        }
        
        return vc
    }
    
    private func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }

//    private func setBackgroundImage(backgroundImage: UIImage?, forState state: UIControlState, barMetrics: UIBarMetrics){
//
//    }
//
//    private func setDividerImage(dividerImage: UIImage?, forLeftSegmentState leftState: UIControlState, rightSegmentState rightState: UIControlState, barMetrics: UIBarMetrics){
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
