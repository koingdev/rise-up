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
import SwiftSoup

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //default home title
    var screenTitle = Constant.DEFAULT_SCREEN_TITLE
    //array for storing article data
    var riseUpArr: [RiseUp] = []
    var urlPage = 1
    //indicator when loading table view
    var activityIndicatorView : UIActivityIndicatorView!
    //table view footer contains loading indicator
    var footerCell: UITableViewCell!
    //background color
    var bgColor = UIColor(red: 215/255.0, green: 243/255.0, blue: 248/255.0, alpha: 0.6)
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblFeedback: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = screenTitle
        self.lblFeedback.isHidden = true
        //set the background color of tableview
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = self.bgColor
        
        //add footerCell to tableFooterView
        //if scrolling to bottom event not hapen, footerCell is hidden
        //And when the event happens, footerCell is shown, but if data on next page not exist it will hide
        footerCell = tableView.dequeueReusableCell(withIdentifier: "loading_next")
        self.tableView.tableFooterView = footerCell
        self.tableView.tableFooterView?.isHidden = true
        
        //to make side bar menu works
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 120
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        //start loading indicator
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.tableView.backgroundView = activityIndicatorView
        activityIndicatorView?.startAnimating()

        //loading data
        self.loadData(page: urlPage)
    }

    func loadData(page: Int){
        var fullUrl = ""
        //compare the screen title to generate each url of the screen
        switch self.screenTitle{
            case Constant.ANDROID_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.ANDROID_URL + String(page)
                break
            case Constant.API_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.API_URL + String(page)
                break
            case Constant.CMS_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.CMS_URL + String(page)
                break
            case Constant.CONCEPT_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.CONCEPT_URL + String(page)
                break
            case Constant.DB_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.DB_URL + String(page)
                break
            case Constant.IOS_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.IOS_URL + String(page)
                break
            case Constant.NEWS_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.NEWS_URL + String(page)
                break
            case Constant.TOOL_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.TOOL_URL + String(page)
                break
            case Constant.UIUX_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.UIUX_URL + String(page)
                break
            case Constant.WEB_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.WEB_URL + String(page)
                break
            default:
                fullUrl = Constant.MAIN_URL + Constant.ANDROID_URL + String(page)
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
                }catch Exception.Error(let type, let message){
                    self.activityIndicatorView.stopAnimating()
                }catch{
                    self.activityIndicatorView.stopAnimating()
                }
                
            case .failure(let error):
                if self.urlPage == 1 {
                    //hide the activityIndicatorView and show feed back
                    self.lblFeedback.isHidden = false
                    self.lblFeedback.text = Constant.FEEDBACK
                } else {
                    //when next page data not found, hide the footer indicator
                    self.footerCell.isHidden = true
                    print("No data found!!!")
                }
            }
            //stop animate the loading indicator
            self.activityIndicatorView.stopAnimating()
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
        cell.cardView.layer.cornerRadius = 20.0
        cell.cardView.layer.borderWidth = 1.2
        cell.cardView.layer.borderColor = UIColor.black.cgColor

        return cell
    }

    //scroll to bottom of tabe view, this function invoke
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.riseUpArr.count - 1 {
            urlPage += 1
            self.loadData(page: urlPage)
            //show the loading indicator at the footer of tableview
            self.footerCell.isHidden = false
            print("loading page: \(urlPage)")
        }
    }

}
