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
    
    //use for storing the url data passed from HomeVC when user click on row
    var url = ""

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //load the web view
        self.loadHtml()
    }
    
    func loadHtml(){
        Alamofire.request(self.url, method: .get).validate().responseString { response in
            switch response.result {
            case .success(let value):
                var replaceText = ""
                let html = value
                
                //exclude <header>
                replaceText = "<header style='display:none;'"
                let exclude1 = html.replacingOccurrences(of: "<header", with: replaceText)
                var resultContent = exclude1
                
                //exclude <aside>
                replaceText = "<aside style='display:none;'"
                let exclude2 = resultContent.replacingOccurrences(of: "<aside", with: replaceText)
                resultContent = exclude2
                
                //exclude article border right and set width to 100%
                replaceText = "<article style='border:none;width:100%;"
                let exclude3 = resultContent.replacingOccurrences(of: "<article", with: replaceText)
                resultContent = exclude3
                
                //align content to center
                replaceText = "<body style='margin:0 auto;'"
                let exclude4 = resultContent.replacingOccurrences(of: "<body", with: replaceText)
                resultContent =  exclude4
                
                self.webView.loadHTMLString(resultContent, baseURL: nil)
                
            case .failure(let error):
                print(error)
            }
        }

    }
}
