//
//  RegistrationTestViewController.swift
//  SeniorProject
//
//  Created by Angie on 5/12/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class RegistrationTestViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let v1:RegisterDetail1ViewController = RegisterDetail1ViewController(nibName: "RegisterDetail1ViewController", bundle: nil)
        let v2:RegisterDetail2ViewController = RegisterDetail2ViewController(nibName: "RegisterDetail2ViewController", bundle: nil)
        
        self.addChildViewController(v1)
        self.scrollView.addSubview(v1.view)
        v1.didMove(toParentViewController: self)
        self.addChildViewController(v2)
        self.scrollView.addSubview(v2.view)
        v2.didMove(toParentViewController: self)
        
        var V2Frame:CGRect = v2.view.frame
        V2Frame.origin.x = self.view.frame.width
        v2.view.frame = V2Frame
        
        self.scrollView.contentSize = CGSize.init(width: self.view.frame.width * 2, height: view.frame.height-80)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
