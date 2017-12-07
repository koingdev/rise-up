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
import SwiftSoup

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //default home title
    var screenTitle = Constant.DEFAULT_SCREEN_TITLE
    //array for storing article data
    var riseUpArr: [RiseUp] = []
    var urlPage = 1
    //loading indicator
    var activityIndicatorView : UIActivityIndicatorView!
    var isLoading = true
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = screenTitle
        
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 180
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        //start loading indicator
        if isLoading {
            activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            self.tableView.backgroundView = activityIndicatorView
            activityIndicatorView?.startAnimating()
        }

        //loading data
        self.loadData(page: urlPage)
    }

    func loadData(page: Int){
        var fullUrl = ""
        //compare the screen title to generate each url of the screen
        switch self.screenTitle{
            case "Android":
                fullUrl = Constant.MAIN_URL + Constant.ANDROID + String(page)
                break
            case "API":
                fullUrl = Constant.MAIN_URL + Constant.API + String(page)
                break
            case "CMS":
                fullUrl = Constant.MAIN_URL + Constant.CMS + String(page)
                break
            case "Concept":
                fullUrl = Constant.MAIN_URL + Constant.CONCEPT + String(page)
                break
            case "Database":
                fullUrl = Constant.MAIN_URL + Constant.DB + String(page)
                break
            case "iOS":
                fullUrl = Constant.MAIN_URL + Constant.IOS + String(page)
                break
            case "News":
                fullUrl = Constant.MAIN_URL + Constant.NEWS + String(page)
                break
            case "Tool":
                fullUrl = Constant.MAIN_URL + Constant.TOOL + String(page)
                break
            case "UI/UX":
                fullUrl = Constant.MAIN_URL + Constant.UIUX + String(page)
                break
            case "Web":
                fullUrl = Constant.MAIN_URL + Constant.WEB + String(page)
                break
            default:
                fullUrl = Constant.MAIN_URL + Constant.ANDROID + String(page)
        }
        //request to the server with Alamofire and extract data withSwiftSOUP
        Alamofire.request(fullUrl, method: .get).validate().responseString { response in
            switch response.result {
            case .success(let value):
                do{
                    let doc: Document = try! SwiftSoup.parse(value)
                    let element = try! doc.select("div#content_box")
                    let items = try! element.select("div.post").array()
                    for item in items{
                        let title = try! item.select("h2.title").text()
                        let url = try! item.select("a").attr("href")
                        let image = try! item.select("img").attr("src")
                        let date = try! item.select("span.thetime").text()
                        let data = RiseUp(title: title, url: url, image: image, date: date)
                        //append data to an array
                        self.riseUpArr.append(data)
                    }
                    //reload the table view if data exists
                    self.tableView.reloadData()
                    self.isLoading = false
                }catch Exception.Error(let type, let message){
                    print(message)
                }catch{
                    print("error")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //when user click on each row, send the content url to ContentVC to open in WebView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "content" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let currentRowIndex = indexPath.row
                let currentUrl = self.riseUpArr[currentRowIndex].url
                let contentView = segue.destination as! ContentVC
                contentView.url = currentUrl!
            }
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
        //styling the row layout
        cell.cardView.layer.masksToBounds = true
        cell.cardView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        cell.cardView.layer.cornerRadius = 20.0
        cell.cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        cell.cardView.layer.shadowOffset = CGSize(width: 0, height: 2)

        return cell
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let actualPos = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height - self.tableView.frame.size.height
//        if actualPos >= contentHeight {
//            if urlPage < urlPage + 1 {
//                urlPage = urlPage + 1
//                print("loading page: \(urlPage)")
//                self.loadData(page: urlPage)
//            }
//        }
//    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.riseUpArr.count - 1 { //you might decide to load sooner than -1 I guess...
            urlPage += 1
            self.loadData(page: urlPage)
            print("loading page: \(urlPage)")
        }
    }

}
