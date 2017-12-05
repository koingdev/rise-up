//
//  MenuVC.swift
//  rise-up
//
//  Created by koingdev on 12/4/17.
//  Copyright © 2017 koingdev. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func navigateToOne(_ sender: Any) {
        performSegue(withIdentifier: "screen-one", sender: nil)
    }
    @IBAction func navigateToHome(_ sender: Any) {
        performSegue(withIdentifier: "screen-home", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //passing data from MenuVC to ScreenOneVC
        if segue.identifier == "screen-one" {
            let data = "Title from MenuVC"
            let view = segue.destination as! UINavigationController
            let rootView = view.topViewController as! ScreenOneVC
            rootView.myTitle = data
        }
    }
}
