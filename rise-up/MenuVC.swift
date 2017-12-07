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

    func openScreen(){
        performSegue(withIdentifier: "riseup", sender: nil)
    }
    
    @IBAction func navigateAndroid(_ sender: Any) {
        self.menu = Constant.ANDROID_SCREEN_TITLE
        self.openScreen()
    }
    @IBAction func navigateIos(_ sender: Any) {
        self.menu = Constant.IOS_SCREEN_TITLE
        self.openScreen()
    }
    @IBAction func navigateApi(_ sender: Any) {
        self.menu = Constant.API_SCREEN_TITLE
        self.openScreen()
    }
    @IBAction func navigateWeb(_ sender: Any) {
        self.menu = Constant.WEB_SCREEN_TITLE
        self.openScreen()
    }
    @IBAction func navigateTool(_ sender: Any) {
        self.menu = Constant.TOOL_SCREEN_TITLE
        self.openScreen()
    }
    @IBAction func navigateConcept(_ sender: Any) {
        self.menu = Constant.CONCEPT_SCREEN_TITLE
        self.openScreen()
    }
    @IBAction func navigateNews(_ sender: Any) {
        self.menu = Constant.NEWS_SCREEN_TITLE
        self.openScreen()
    }
    @IBAction func navigateCms(_ sender: Any) {
        self.menu = Constant.CMS_SCREEN_TITLE
        self.openScreen()
    }
    @IBAction func navigateDb(_ sender: Any) {
        self.menu = Constant.DB_SCREEN_TITLE
        self.openScreen()
    }
    @IBAction func navigateUiux(_ sender: Any) {
        self.menu = Constant.UIUX_SCREEN_TITLE
        self.openScreen()
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
