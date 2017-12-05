//
//  ViewController.swift
//  rise-up
//
//  Created by koingdev on 12/4/17.
//  Copyright © 2017 koingdev. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //default home title
    var screenTitle = "Android"
    var baseUrl = "http://192.168.1.102/riseup/View/"
    var fullUrl = ""
    var riseUpArr: [RiseUp] = []
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = screenTitle
        self.fullUrl = baseUrl + self.screenTitle + ".php"
        Alamofire.request(self.fullUrl, method: .get).validate().responseJSON { response in
            switch response.result {
                case .success(let value):
                    let jsonArray = JSON(value)
                    for (_, json) in jsonArray{
                        let title = json["title"].string!
                        let url = json["url"].string!
                        let image = json["image"].string!
                        let author = json["author"].string!
                        let date = json["date"].string!
                        let data = RiseUp(title: title, url: url, image: image,
                                          author: author, date: date)
                        self.riseUpArr.append(data)
                    }
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error)
            }
        }

        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }

    //number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.riseUpArr.count
    }
    //load data into each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a resusable cell and case it to CategoryCell, then pass to cell variable
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RiseUpCell
        let riseUp = self.riseUpArr[indexPath.row]
        //render the cell data
        cell.lblTitle.text = riseUp.title!
        cell.lblDate.text = riseUp.date!
        Alamofire.request(riseUp.image!).responseImage { response in
            if let image = response.result.value {
                cell.imgImage.image = image
            }
        }
        cell.layer.cornerRadius = 8
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 2
        self.view.addSubview(self.tableView)
        return cell
    }

}
