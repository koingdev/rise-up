//
//  ContentVC.swift
//  rise-up
//
//  Created by koingdev on 12/6/17.
//  Copyright © 2017 koingdev. All rights reserved.
//

import UIKit
import Alamofire

class ContentVC: UIViewController {
    
    var url = ""

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadHtml()
    }
    
    func loadHtml(){
        Alamofire.request(self.url, method: .get).validate().responseString { response in
            switch response.result {
            case .success(let value):
                let html = value
                print(html)
                self.webView.loadHTMLString(html, baseURL: nil)
            
            case .failure(let error):
                print(error)
            }
        }

    }
}
