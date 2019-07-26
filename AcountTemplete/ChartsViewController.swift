//
//  ChartsViewController.swift
//  AcountTemplete
//
//  Created by Wallance on 2019/7/25.
//  Copyright © 2019 Wallance. All rights reserved.
//

import UIKit
import SWRevealViewController
class ChartsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let revealVC = revealViewController(){
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
//            menuButton.target = revealVC
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
