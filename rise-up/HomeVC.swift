//
//  ViewController.swift
//  rise-up
//
//  Created by koingdev on 12/4/17.
//  Copyright © 2017 koingdev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeVC: UIViewController {

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    var riseUpArr = [RiseUp]()
    var data = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home Screen"
        
//        Alamofire.request("http://koingapi.000webhostapp.com/training.php").responseJSON { response in
//            if response.response?.statusCode == 200 {
//                self.title = "Done"
//                if let json = response.result.value {
//                    print(json) 
//                }
//            }
//        }
        Alamofire.request("http://192.168.1.3/riseup/View/Android.php", method: .get).validate().responseJSON { response in
            switch response.result {
                case .success(let value):
                    let jsonArray = JSON(value)
                    for (_, json) in jsonArray{
                        let title = json["title"].string!
                        self.data = title
                        let url = json["url"].string!
                        let image = json["image"].string!
                        let author = json["author"].string!
                        let date = json["date"].string!
                        var riseUp = RiseUp(title: title, url: url, image: image,
                                            author: author, date: date)
                        self.riseUpArr.append(riseUp)
                    }

                case .failure(let error):
                    print(error)
            }
        }
        print(self.data)
        
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }

}

