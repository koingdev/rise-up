//
//  MenuVC.swift
//  rise-up
//
//  Created by koingdev on 12/4/17.
//  Copyright © 2017 koingdev. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    //use for passing to HomeVC in order to change the navigation bar title
    var menu = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func navigateToOne(_ sender: Any) {
        self.menu = "iOS"
        performSegue(withIdentifier: "riseup", sender: nil)
    }
    @IBAction func navigateToHome(_ sender: Any) {
        self.menu = "Android"
        performSegue(withIdentifier: "riseup", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //passing data from MenuVC to ScreenOneVC
        if segue.identifier == "riseup" {
            let view = segue.destination as! UINavigationController
            let rootView = view.topViewController as! HomeVC
            rootView.screenTitle = self.menu
        }
    }
}
