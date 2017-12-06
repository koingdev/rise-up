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
    var baseUrl = "http://192.168.1.9/riseup/View/"
    var fullUrl = ""
    var riseUpArr: [RiseUp] = []
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = screenTitle
        
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 150
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        self.loadData()
    }

    func loadData(){
        //compare the screen title to generate each url of the screen
        switch self.screenTitle{
            case "Android":
                self.fullUrl = baseUrl + "Android.php"
                break
            case "API":
                self.fullUrl = baseUrl + "Api.php"
                break
            case "CMS":
                self.fullUrl = baseUrl + "Cms.php"
                break
            case "Concept":
                self.fullUrl = baseUrl + "Concept.php"
                break
            case "Database":
                self.fullUrl = baseUrl + "Database.php"
                break
            case "iOS":
                self.fullUrl = baseUrl + "Ios.php"
                break
            case "News":
                self.fullUrl = baseUrl + "News.php"
                break
            case "Tool":
                self.fullUrl = baseUrl + "Tool.php"
                break
            case "UI/UX":
                self.fullUrl = baseUrl + "UiUx.php"
                break
            case "Web":
                self.fullUrl = baseUrl + "Web.php"
                break
            default:
                self.fullUrl = baseUrl + "Android.php"
        }
        //request to the server using Alamofire framework to get JSON response
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
    }
    
    //number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return riseUpArr.count
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
        //styling the row layout
        cell.cardView.layer.masksToBounds = true
        cell.cardView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        cell.cardView.layer.cornerRadius = 20.0
        cell.cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        cell.cardView.layer.shadowOffset = CGSize(width: 0, height: 2)

        return cell
    }

}
