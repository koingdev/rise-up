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
    //indicator when loading web view
    var activityIndicatorView : UIActivityIndicatorView!

    @IBOutlet weak var lblFeedback: UILabel!
    @IBOutlet weak var webView: UIWebView!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblFeedback.isHidden = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControlEvents.valueChanged)
        self.webView.scrollView.addSubview(refreshControl)
        
        //set up loading indicator
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        //add it to the middle of the screen
        activityIndicatorView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.webView.frame.size.height / 2)
        self.webView.addSubview(activityIndicatorView)
        //start animate indicator
        activityIndicatorView?.startAnimating()
        
        //load the web view
        self.loadHtml()
    }
    
    //pull to refresh web view
    func refresh(_ refreshControl: UIRefreshControl) {
        activityIndicatorView?.startAnimating()
        //reset current web view content
        self.webView.loadHTMLString("", baseURL: nil)
        //reload webview
        self.loadHtml()
        //end refreshing
        self.refreshControl?.endRefreshing()
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
                //hide the activityIndicatorView and show feed back
                self.lblFeedback.isHidden = false
                self.lblFeedback.text = Constant.FEEDBACK
            }
            //stop animate the loading indicator
            self.activityIndicatorView.stopAnimating()
        }
    }
}
